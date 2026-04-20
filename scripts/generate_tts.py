#!/usr/bin/env python3
"""Hybrid TTS generation.

Runs in CI. Two stages:

1.  **Piper (free)** — free, fully offline, Apache-licensed Turkish voice.
    Generates an MP3 for every vocabulary entry and every example
    sentence extracted from `TurkishCEFR/Data/Content/*Content*.swift`.
    These MP3s are bundled into the `.app` so the end user never needs
    network access to hear Turkish.

2.  **ElevenLabs (paid, optional)** — activated only when
    `ELEVEN_LABS_API_KEY` is set in the CI environment. Used for a small
    set of premium dialogue lines curated in
    `TurkishCEFR/Data/Content/DialoguesContent.swift`. The resulting MP3s
    are bundled identically. No API key is ever embedded in the built
    `.app` — only the CI runner sees the secret.

Output location: `TurkishCEFR/Resources/Audio/{piper,premium}/*.mp3`
These directories are referenced by the Xcode project (see
`project.yml`) and copied into the app bundle.
"""
from __future__ import annotations

import hashlib
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT_DIR = REPO_ROOT / "TurkishCEFR" / "Data" / "Content"
AUDIO_ROOT = REPO_ROOT / "TurkishCEFR" / "Resources" / "Audio"
PIPER_DIR = AUDIO_ROOT / "piper"
PREMIUM_DIR = AUDIO_ROOT / "premium"
MANIFEST = AUDIO_ROOT / "manifest.json"

# Piper voice ("Turkish female, Istanbul accent, 22 kHz").
# The model and config file come from the rhasspy/piper-voices repo on
# Hugging Face. We host the URL here so the CI job stays deterministic.
PIPER_MODEL = {
    "name": "tr_TR-dfki-medium",
    "onnx_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/tr/tr_TR/dfki/medium/tr_TR-dfki-medium.onnx",
    "json_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/tr/tr_TR/dfki/medium/tr_TR-dfki-medium.onnx.json",
}

# Rough safety limit so a misconfigured corpus fetch doesn't run us
# out of disk on the runner.
MAX_TTS_PHRASES = 6000

# Extract Turkish strings from a VocabularyEntry init block or a
# plain .turkish("…") call — good enough for our literal Swift
# content files.
PHRASE_PATTERN = re.compile(
    r'(?:turkish|titleTR|question|prompt|sentence|phrase|example)\s*:\s*"([^"]{2,160})"'
)


def _sha(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()[:16]


def _safe_name(text: str) -> str:
    return _sha(text) + ".mp3"


def _extract_phrases() -> list[str]:
    seen: set[str] = set()
    phrases: list[str] = []
    for path in sorted(CONTENT_DIR.glob("*Content*.swift")):
        text = path.read_text(encoding="utf-8", errors="ignore")
        for m in PHRASE_PATTERN.finditer(text):
            phrase = m.group(1).strip()
            # Drop obviously-English captions (useful heuristic — if a
            # string has zero Turkish-only characters and is all ASCII,
            # we assume it's the English translation we accidentally
            # caught).
            if phrase.lower() == phrase and all(ord(c) < 128 for c in phrase) and " " not in phrase:
                continue
            if phrase in seen:
                continue
            seen.add(phrase)
            phrases.append(phrase)
            if len(phrases) >= MAX_TTS_PHRASES:
                return phrases
    return phrases


def _fetch(url: str, dest: pathlib.Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(url, headers={"User-Agent": "TurkishCEFR-tts/1.0"})
    with urllib.request.urlopen(req, timeout=60) as resp, open(dest, "wb") as f:
        shutil.copyfileobj(resp, f)


def _ensure_piper() -> tuple[pathlib.Path, pathlib.Path, pathlib.Path]:
    """Return (piper_binary, voice_onnx, voice_json)."""
    cache = pathlib.Path(os.environ.get("PIPER_CACHE", REPO_ROOT / ".piper-cache"))
    cache.mkdir(parents=True, exist_ok=True)

    # Piper binary — prefer a system install, fall back to pip wheel.
    binary = shutil.which("piper")
    if binary is None:
        # `pip install piper-tts` ships a CLI named `piper` in the same
        # venv bin dir. Install quietly so CI stays self-contained.
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--quiet", "piper-tts==1.2.0"])
        binary = shutil.which("piper")
    if binary is None:
        raise RuntimeError("Failed to install piper-tts")

    onnx = cache / "tr_TR-dfki-medium.onnx"
    json_ = cache / "tr_TR-dfki-medium.onnx.json"
    if not onnx.exists():
        print(f"Downloading Piper model → {onnx}")
        _fetch(PIPER_MODEL["onnx_url"], onnx)
    if not json_.exists():
        print(f"Downloading Piper config → {json_}")
        _fetch(PIPER_MODEL["json_url"], json_)
    return pathlib.Path(binary), onnx, json_


def _piper_say(binary: pathlib.Path, onnx: pathlib.Path, text: str, out_mp3: pathlib.Path) -> bool:
    """Run Piper to produce a WAV, then encode to MP3 with ffmpeg.

    Returns True on success. We skip silently on failure so a single bad
    phrase doesn't fail the whole CI job.
    """
    with tempfile.TemporaryDirectory() as tmpd:
        wav = pathlib.Path(tmpd) / "out.wav"
        try:
            subprocess.run(
                [str(binary), "--model", str(onnx), "--output_file", str(wav)],
                input=text.encode("utf-8"),
                check=True,
                capture_output=True,
                timeout=30,
            )
        except subprocess.CalledProcessError as e:
            print(f"Piper failed for '{text[:40]}…' → {e.stderr.decode(errors='ignore')[:120]}", file=sys.stderr)
            return False
        out_mp3.parent.mkdir(parents=True, exist_ok=True)
        try:
            subprocess.run(
                [
                    "ffmpeg", "-y", "-loglevel", "error",
                    "-i", str(wav),
                    "-codec:a", "libmp3lame",
                    "-qscale:a", "4",
                    str(out_mp3),
                ],
                check=True,
                timeout=30,
            )
        except subprocess.CalledProcessError as e:
            print(f"ffmpeg failed for '{text[:40]}…'", file=sys.stderr)
            return False
    return True


def _generate_piper(phrases: list[str]) -> dict[str, str]:
    """Returns map of phrase → mp3 relative path."""
    PIPER_DIR.mkdir(parents=True, exist_ok=True)
    binary, onnx, _json = _ensure_piper()

    result: dict[str, str] = {}
    todo = []
    for p in phrases:
        mp3 = PIPER_DIR / _safe_name(p)
        if mp3.exists():
            result[p] = str(mp3.relative_to(AUDIO_ROOT))
        else:
            todo.append((p, mp3))

    print(f"Piper: {len(result)} cached, {len(todo)} to synthesise")
    if not todo:
        return result

    for phrase, mp3 in todo:
        if _piper_say(binary, onnx, phrase, mp3):
            result[phrase] = str(mp3.relative_to(AUDIO_ROOT))
    return result


# ----------------------------- ElevenLabs -----------------------------

ELEVEN_API_KEY_ENV = "ELEVEN_LABS_API_KEY"
# "Rachel" is ElevenLabs's default multilingual voice. If the user
# configured their own `ELEVEN_LABS_VOICE_ID` we honour it.
DEFAULT_VOICE_ID = "21m00Tcm4TlvDq8ikWAM"


def _extract_premium_lines() -> list[str]:
    """Small hand-picked line pool for ElevenLabs. Free tier = ~10k chars/month."""
    src = CONTENT_DIR / "DialoguesContent.swift"
    if not src.exists():
        return []
    text = src.read_text(encoding="utf-8", errors="ignore")
    seen: set[str] = set()
    out: list[str] = []
    for m in re.finditer(r'line\s*\(\s*"([^"]{2,180})"', text):
        line = m.group(1).strip()
        if line in seen:
            continue
        seen.add(line)
        out.append(line)
        # Hard cap to stay inside free tier.
        if sum(len(x) for x in out) > 9000:
            break
    return out


def _generate_eleven(phrases: list[str], api_key: str) -> dict[str, str]:
    PREMIUM_DIR.mkdir(parents=True, exist_ok=True)
    voice_id = os.environ.get("ELEVEN_LABS_VOICE_ID", DEFAULT_VOICE_ID)

    out: dict[str, str] = {}
    for phrase in phrases:
        mp3 = PREMIUM_DIR / _safe_name(phrase)
        if mp3.exists():
            out[phrase] = str(mp3.relative_to(AUDIO_ROOT))
            continue
        url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
        req = urllib.request.Request(
            url,
            method="POST",
            data=json.dumps({
                "text": phrase,
                "model_id": "eleven_multilingual_v2",
                "voice_settings": {"stability": 0.55, "similarity_boost": 0.7},
            }).encode("utf-8"),
            headers={
                "xi-api-key": api_key,
                "Content-Type": "application/json",
                "Accept": "audio/mpeg",
            },
        )
        try:
            with urllib.request.urlopen(req, timeout=45) as resp, open(mp3, "wb") as f:
                shutil.copyfileobj(resp, f)
            out[phrase] = str(mp3.relative_to(AUDIO_ROOT))
        except urllib.error.HTTPError as e:
            print(f"ElevenLabs HTTP {e.code} for '{phrase[:40]}…' — stopping premium pass", file=sys.stderr)
            break
        except Exception as e:
            print(f"ElevenLabs failed for '{phrase[:40]}…': {e}", file=sys.stderr)
            continue
    return out


# ------------------------------- main ---------------------------------

def main() -> int:
    phrases = _extract_phrases()
    print(f"Extracted {len(phrases)} unique Turkish phrases from content")

    manifest = {
        "piper": {},
        "premium": {},
        "version": 1,
    }

    # Piper is mandatory; without it we have no offline audio.
    try:
        manifest["piper"] = _generate_piper(phrases)
    except Exception as e:
        print(f"Piper stage failed — continuing without offline audio: {e}", file=sys.stderr)

    key = os.environ.get(ELEVEN_API_KEY_ENV, "").strip()
    premium_phrases = _extract_premium_lines()
    if key and premium_phrases:
        try:
            manifest["premium"] = _generate_eleven(premium_phrases, key)
        except Exception as e:
            print(f"ElevenLabs stage failed: {e}", file=sys.stderr)
    elif not key:
        print("ELEVEN_LABS_API_KEY not set — skipping premium dialogue TTS")

    AUDIO_ROOT.mkdir(parents=True, exist_ok=True)
    MANIFEST.write_text(json.dumps(manifest, indent=2, ensure_ascii=False))
    print(f"Wrote manifest: {MANIFEST.relative_to(REPO_ROOT)}")
    print(f"Piper MP3s: {len(manifest['piper'])}  ·  Premium MP3s: {len(manifest['premium'])}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
