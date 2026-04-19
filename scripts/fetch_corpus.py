#!/usr/bin/env python3
"""
Build-time corpus fetcher. Pulls open Turkish language data from public,
permissively-licensed sources and bakes it into the `.app` as JSON so the app
stays fully offline at runtime.

Sources:
  * Tatoeba (CC-BY 2.0 FR) — Turkish sentences + Turkish↔English links.
      https://downloads.tatoeba.org/exports/per_language/
  * hermitdave/FrequencyWords (MIT) — Turkish frequency list derived from
    OpenSubtitles.
      https://raw.githubusercontent.com/hermitdave/FrequencyWords/master/content/2018/tr/tr_50k.txt

Output files (written to TurkishCEFR/Resources/):
  * corpus_tr_en.json  — array of {"tr": ..., "en": ..., "len": N} ready for
                         the in-app dictionary, daily challenge, and SRS deck.
  * frequency_tr.json  — array of {"word": "...", "rank": N, "count": C} sorted
                         by usage frequency (top ≈ 10 000 words).

The script is deliberately tolerant: if network fetches fail (offline CI
environment, GitHub Actions outage, etc.) it still writes a small embedded
fallback so `xcodebuild` never breaks because of missing resources.
"""
from __future__ import annotations

import bz2
import json
import os
import sys
import urllib.request
from pathlib import Path
from typing import Iterable


REPO_ROOT = Path(__file__).resolve().parent.parent
RES_DIR = REPO_ROOT / "TurkishCEFR" / "Resources"
RES_DIR.mkdir(parents=True, exist_ok=True)

TUR_URL = "https://downloads.tatoeba.org/exports/per_language/tur/tur_sentences.tsv.bz2"
ENG_URL = "https://downloads.tatoeba.org/exports/per_language/eng/eng_sentences.tsv.bz2"
LINKS_URL = "https://downloads.tatoeba.org/exports/per_language/tur/tur-eng_links.tsv.bz2"
FREQ_URL = "https://raw.githubusercontent.com/hermitdave/FrequencyWords/master/content/2018/tr/tr_50k.txt"

MAX_PAIRS = 20_000
MAX_WORDS = 10_000
MIN_LEN = 5
MAX_LEN = 90


def log(msg: str) -> None:
    print(f"[fetch_corpus] {msg}", flush=True)


def download(url: str, dest: Path, timeout: int = 120) -> bool:
    try:
        log(f"GET {url}")
        req = urllib.request.Request(url, headers={"User-Agent": "TurkishCEFR-build/1.0"})
        with urllib.request.urlopen(req, timeout=timeout) as resp, open(dest, "wb") as out:
            out.write(resp.read())
        return dest.stat().st_size > 1024
    except Exception as exc:  # noqa: BLE001
        log(f"failed: {exc}")
        return False


def read_bz2_tsv(path: Path) -> Iterable[list[str]]:
    with bz2.open(path, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            parts = line.rstrip("\n").split("\t")
            if parts:
                yield parts


def build_corpus(tmp: Path) -> list[dict]:
    tur_f = tmp / "tur.tsv.bz2"
    eng_f = tmp / "eng.tsv.bz2"
    lnk_f = tmp / "links.tsv.bz2"

    ok = all([
        download(TUR_URL, tur_f),
        download(ENG_URL, eng_f),
        download(LINKS_URL, lnk_f),
    ])
    if not ok:
        return []

    log("reading Turkish sentences…")
    tur: dict[str, str] = {}
    for row in read_bz2_tsv(tur_f):
        if len(row) >= 3:
            tur[row[0]] = row[2].strip()

    log("reading English sentences…")
    eng: dict[str, str] = {}
    for row in read_bz2_tsv(eng_f):
        if len(row) >= 3:
            eng[row[0]] = row[2].strip()

    log("joining via tur↔eng links…")
    pairs: list[dict] = []
    seen_tr: set[str] = set()
    for row in read_bz2_tsv(lnk_f):
        if len(row) < 2:
            continue
        tr_id, en_id = row[0], row[1]
        t = tur.get(tr_id)
        e = eng.get(en_id)
        if not t or not e:
            continue
        tl, el = len(t), len(e)
        if tl < MIN_LEN or tl > MAX_LEN or el < MIN_LEN or el > MAX_LEN:
            continue
        key = t.lower()
        if key in seen_tr:
            continue
        seen_tr.add(key)
        pairs.append({"tr": t, "en": e, "len": tl})
        if len(pairs) >= MAX_PAIRS:
            break

    pairs.sort(key=lambda p: p["len"])
    log(f"collected {len(pairs)} curated pairs")
    return pairs


def build_frequency(tmp: Path) -> list[dict]:
    dest = tmp / "freq.txt"
    if not download(FREQ_URL, dest):
        return []
    rows: list[dict] = []
    with open(dest, "r", encoding="utf-8", errors="replace") as f:
        for idx, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            parts = line.split()
            if len(parts) < 2:
                continue
            word, count = parts[0], parts[1]
            if not word.isalpha() or len(word) < 2:
                continue
            try:
                count_i = int(count)
            except ValueError:
                continue
            rows.append({"word": word, "rank": idx + 1, "count": count_i})
            if len(rows) >= MAX_WORDS:
                break
    log(f"collected {len(rows)} frequency entries")
    return rows


def write_json(name: str, payload: object) -> None:
    out = RES_DIR / name
    with open(out, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, separators=(",", ":"))
    log(f"wrote {out.relative_to(REPO_ROOT)} ({out.stat().st_size/1024:.0f} KB)")


def fallback_corpus() -> list[dict]:
    return [
        {"tr": "Merhaba.", "en": "Hello.", "len": 8},
        {"tr": "Nasılsın?", "en": "How are you?", "len": 9},
        {"tr": "İyiyim, teşekkür ederim.", "en": "I'm fine, thank you.", "len": 24},
        {"tr": "Adın ne?", "en": "What's your name?", "len": 8},
        {"tr": "Benim adım Ali.", "en": "My name is Ali.", "len": 15},
        {"tr": "Seni seviyorum.", "en": "I love you.", "len": 15},
        {"tr": "Bugün hava çok güzel.", "en": "The weather is lovely today.", "len": 21},
    ]


def fallback_frequency() -> list[dict]:
    return [
        {"word": w, "rank": i + 1, "count": 10_000 - i * 10}
        for i, w in enumerate([
            "ve", "bir", "bu", "için", "ne", "gibi", "daha", "çok", "de", "o",
            "ama", "sen", "ben", "ya", "ki", "var", "yok", "evet", "hayır", "merhaba",
        ])
    ]


def main() -> int:
    tmp = Path(os.environ.get("TURKISHCEFR_TMP", "/tmp/tcefr_corpus"))
    tmp.mkdir(parents=True, exist_ok=True)

    pairs = build_corpus(tmp)
    if not pairs:
        log("falling back to embedded corpus")
        pairs = fallback_corpus()
    write_json("corpus_tr_en.json", pairs)

    freq = build_frequency(tmp)
    if not freq:
        log("falling back to embedded frequency list")
        freq = fallback_frequency()
    write_json("frequency_tr.json", freq)

    return 0


if __name__ == "__main__":
    sys.exit(main())
