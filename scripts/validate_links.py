#!/usr/bin/env python3
"""Weekly CI job: walks every YouTube reference in
`TurkishCEFR/Data/Content/LessonResources.swift` and pings the public
oEmbed endpoint. Any 404/401/403 produces an entry in the report which
is then turned into a GitHub issue by the calling workflow.

This script is intentionally dependency-free so the cron job stays
fast and reliable.
"""
from __future__ import annotations

import json
import pathlib
import re
import sys
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = REPO_ROOT / "TurkishCEFR" / "Data" / "Content" / "LessonResources.swift"

ID_PATTERN = re.compile(
    r'\.init\(youtubeID:\s*"([^"]+)"\s*,\s*'
    r'title:\s*"([^"]+)"\s*,\s*'
    r'channel:\s*"([^"]+)"',
    re.DOTALL,
)

OEMBED_FMT = (
    "https://www.youtube.com/oembed?"
    "url=https://www.youtube.com/watch?v={id}&format=json"
)


def extract_refs(text: str) -> list[dict]:
    refs = []
    for m in ID_PATTERN.finditer(text):
        refs.append({
            "id": m.group(1),
            "title": m.group(2),
            "channel": m.group(3),
        })
    return refs


def ping(ref: dict, timeout: float = 8.0) -> dict:
    url = OEMBED_FMT.format(id=ref["id"])
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "TurkishCEFR-link-validator/1.0"},
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            status = resp.getcode()
            ok = 200 <= status < 300
            ref_out = {**ref, "status": status, "ok": ok}
            if ok:
                # Confirm JSON body is valid so we know YouTube didn't
                # quietly 200 with an empty payload.
                try:
                    payload = json.load(resp)
                    ref_out["title_from_youtube"] = payload.get("title", "")
                except Exception:
                    ref_out["ok"] = False
                    ref_out["status"] = 0
            return ref_out
    except urllib.error.HTTPError as e:
        return {**ref, "status": e.code, "ok": False}
    except Exception as e:
        return {**ref, "status": 0, "ok": False, "error": str(e)}


def main() -> int:
    text = SOURCE.read_text(encoding="utf-8")
    refs = extract_refs(text)
    if not refs:
        print("No YouTube references found", file=sys.stderr)
        return 1

    print(f"Checking {len(refs)} YouTube references...")

    results: list[dict] = []
    with ThreadPoolExecutor(max_workers=6) as exe:
        futures = {exe.submit(ping, r): r for r in refs}
        for fut in as_completed(futures):
            results.append(fut.result())
            time.sleep(0.05)

    broken = [r for r in results if not r["ok"]]
    broken.sort(key=lambda r: r["id"])

    report = {
        "checked": len(results),
        "broken": len(broken),
        "broken_refs": broken,
    }
    out_path = REPO_ROOT / "link-validation-report.json"
    out_path.write_text(json.dumps(report, indent=2, ensure_ascii=False))

    if broken:
        print(f"{len(broken)} broken link(s):", file=sys.stderr)
        for b in broken:
            print(f"  - [{b.get('status')}] {b['id']} · {b['title']}", file=sys.stderr)
        return 2

    print("All links healthy.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
