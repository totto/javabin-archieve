#!/usr/bin/env python3
"""
fetch-snapshots.py - Systematically fetch java.no Wayback Machine snapshots.

Handles ISO-8859-1 encoding, rate limiting, and saves raw HTML + extracted text.
"""

import os
import sys
import time
import json
import re
import urllib.request
import urllib.error
from pathlib import Path

CDX_API = "https://web.archive.org/cdx/search/cdx"
WAYBACK  = "https://web.archive.org/web"
OUTPUT   = Path(__file__).parent.parent / "wayback-output"
DELAY    = 1.5  # seconds between requests

URLS_TO_FETCH = [
    "www.java.no/",
    "www.java.no/?page=om",
    "www.java.no/?page=moter",
    "www.java.no/?page=helter",
    "www.java.no/om",
    "www.java.no/om/",
    "www.java.no/forum/",
    "www.java.no/forum",
    "www.java.no/artikler",
    "www.java.no/helter",
    "www.java.no/javazone",
    "java.no/",
]


def fetch(url, encoding="iso-8859-1"):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (compatible; research-bot/1.0)"})
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            raw = r.read()
            return raw.decode(encoding, errors="replace")
    except Exception as e:
        print(f"  ERROR: {e}", file=sys.stderr)
        return None


def cdx_snapshots(url_pattern, from_year=1996, to_year=2010, limit=50):
    params = (
        f"?url={url_pattern}&output=json"
        f"&from={from_year}0101&to={to_year}1231"
        f"&fl=timestamp,original,statuscode"
        f"&filter=statuscode:200"
        f"&limit={limit}"
        f"&collapse=timestamp:6"  # one per month
    )
    data = fetch(CDX_API + params)
    if not data:
        return []
    try:
        rows = json.loads(data)
        return rows[1:]  # skip header
    except Exception:
        return []


def extract_text(html):
    text = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
    text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL)
    text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', ' ', text)
    text = re.sub(r'&nbsp;', ' ', text)
    text = re.sub(r'&[a-z]+;', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    (OUTPUT / "html").mkdir(exist_ok=True)
    (OUTPUT / "text").mkdir(exist_ok=True)

    print(f"Output: {OUTPUT}")
    print()

    for url_pattern in URLS_TO_FETCH:
        print(f"=== Fetching CDX for {url_pattern} ===")
        snapshots = cdx_snapshots(url_pattern)
        print(f"  Found {len(snapshots)} monthly snapshots")
        time.sleep(DELAY)

        for row in snapshots:
            ts, original, status = row
            wayback_url = f"{WAYBACK}/{ts}/{original}"
            slug = url_pattern.replace("/", "_").replace("?", "_").strip("_")
            filename = f"{ts}_{slug}"

            html_path = OUTPUT / "html" / f"{filename}.html"
            text_path = OUTPUT / "text" / f"{filename}.txt"

            if html_path.exists():
                print(f"  SKIP {ts} (cached)")
                continue

            print(f"  Fetching {ts} → {original[:50]}")
            html = fetch(wayback_url)
            if not html:
                time.sleep(DELAY)
                continue

            html_path.write_text(html, encoding="utf-8")
            text_path.write_text(extract_text(html), encoding="utf-8")
            print(f"    Saved ({len(html)} bytes)")
            time.sleep(DELAY)

    print()
    print(f"Done. Files in {OUTPUT}/")


if __name__ == "__main__":
    main()
