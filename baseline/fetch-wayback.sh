#!/usr/bin/env bash
#
# fetch-wayback.sh - Fetch java.no snapshots from the Wayback Machine
#
# Run from an unrestricted network (no proxy blocking web.archive.org).
# Creates wayback-output/ with CDX index and downloaded snapshots.
#
# Usage: ./fetch-wayback.sh [--from YEAR] [--to YEAR] [--limit N]
#
set -euo pipefail

FROM_YEAR=1996
TO_YEAR=2010
LIMIT=5000
OUTPUT_DIR="wayback-output"
CDX_API="https://web.archive.org/cdx/search/cdx"
WAYBACK="https://web.archive.org/web"
DELAY=1  # seconds between requests (be polite)

while [[ $# -gt 0 ]]; do
    case $1 in
        --from)  FROM_YEAR="$2"; shift 2 ;;
        --to)    TO_YEAR="$2"; shift 2 ;;
        --limit) LIMIT="$2"; shift 2 ;;
        *)       echo "Unknown option: $1"; exit 1 ;;
    esac
done

mkdir -p "$OUTPUT_DIR"/{pages,forum,news,raw-cdx}

echo "=============================================="
echo " java.no Wayback Machine Fetcher"
echo " Period: $FROM_YEAR - $TO_YEAR"
echo " Output: $OUTPUT_DIR/"
echo "=============================================="
echo ""

# -------------------------------------------------------------------
# Step 1: Fetch complete CDX index for java.no and all subpages
# -------------------------------------------------------------------
echo "[1/6] Fetching CDX index for java.no/* ..."

CDX_URLS=(
    "java.no"
    "java.no/*"
    "www.java.no"
    "www.java.no/*"
)

for url in "${CDX_URLS[@]}"; do
    safe_name=$(echo "$url" | tr '/*' '_-')
    outfile="$OUTPUT_DIR/raw-cdx/cdx-${safe_name}.txt"
    echo "  Fetching CDX: $url -> $outfile"
    curl -s -f \
        "${CDX_API}?url=${url}&output=text&fl=timestamp,original,mimetype,statuscode,length&from=${FROM_YEAR}&to=${TO_YEAR}&limit=${LIMIT}" \
        -o "$outfile" || echo "  WARN: Failed to fetch CDX for $url"
    sleep "$DELAY"
done

# Merge and deduplicate
echo "  Merging CDX files..."
cat "$OUTPUT_DIR"/raw-cdx/cdx-*.txt 2>/dev/null | sort -u > "$OUTPUT_DIR/cdx-all.txt"
total=$(wc -l < "$OUTPUT_DIR/cdx-all.txt")
echo "  Total unique snapshots: $total"

# -------------------------------------------------------------------
# Step 2: Extract HTML-only snapshots
# -------------------------------------------------------------------
echo ""
echo "[2/6] Filtering HTML snapshots..."

grep -i "text/html" "$OUTPUT_DIR/cdx-all.txt" | grep " 200 " > "$OUTPUT_DIR/cdx-html-200.txt" || true
html_count=$(wc -l < "$OUTPUT_DIR/cdx-html-200.txt")
echo "  HTML 200-OK snapshots: $html_count"

# -------------------------------------------------------------------
# Step 3: Identify key page categories
# -------------------------------------------------------------------
echo ""
echo "[3/6] Categorizing snapshots..."

# Main/front page
grep -E "java\.no/?$|java\.no/index" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-frontpage.txt" 2>/dev/null || true

# Forum / discussion pages
grep -iE "forum|diskusjon|thread|topic|message|post|debate" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-forum.txt" 2>/dev/null || true

# News pages
grep -iE "nyhet|news|artikkel|article" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-news.txt" 2>/dev/null || true

# People / member pages
grep -iE "member|bruker|profil|profile|people|styre|board" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-people.txt" 2>/dev/null || true

# Meeting pages
grep -iE "mote|meeting|arrangement|event|presentasjon" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-meetings.txt" 2>/dev/null || true

# Job postings
grep -iE "jobb|stilling|career|job" "$OUTPUT_DIR/cdx-html-200.txt" \
    > "$OUTPUT_DIR/cdx-jobs.txt" 2>/dev/null || true

for cat_file in frontpage forum news people meetings jobs; do
    count=$(wc -l < "$OUTPUT_DIR/cdx-${cat_file}.txt" 2>/dev/null || echo 0)
    echo "  $cat_file: $count snapshots"
done

# -------------------------------------------------------------------
# Step 4: Download front page snapshots (one per quarter)
# -------------------------------------------------------------------
echo ""
echo "[4/6] Downloading front page snapshots (sampled quarterly)..."

download_snapshot() {
    local timestamp="$1"
    local url="$2"
    local category="$3"
    local safe_url
    safe_url=$(echo "$url" | sed 's|https\?://||; s|/|__|g; s|[^a-zA-Z0-9._-]|_|g')
    local outfile="$OUTPUT_DIR/${category}/${timestamp}__${safe_url}.html"

    if [[ -f "$outfile" ]]; then
        echo "    SKIP (exists): $outfile"
        return
    fi

    local wayback_url="${WAYBACK}/${timestamp}id_/${url}"
    echo "    GET: $wayback_url"
    curl -s -f -L --max-time 30 \
        -o "$outfile" \
        "$wayback_url" 2>/dev/null || {
        echo "    WARN: Failed to download $wayback_url"
        rm -f "$outfile"
    }
    sleep "$DELAY"
}

# Sample: pick first snapshot from each quarter
last_quarter=""
while IFS=' ' read -r timestamp url _ _ _; do
    year=${timestamp:0:4}
    month=${timestamp:4:2}
    quarter="${year}Q$(( (10#$month - 1) / 3 + 1 ))"

    if [[ "$quarter" != "$last_quarter" ]]; then
        download_snapshot "$timestamp" "$url" "pages"
        last_quarter="$quarter"
    fi
done < "$OUTPUT_DIR/cdx-frontpage.txt"

# -------------------------------------------------------------------
# Step 5: Download forum snapshots (first 200)
# -------------------------------------------------------------------
echo ""
echo "[5/6] Downloading forum snapshots (up to 200)..."

forum_count=0
while IFS=' ' read -r timestamp url _ _ _; do
    if [[ $forum_count -ge 200 ]]; then
        echo "  Reached 200 forum snapshots, stopping."
        break
    fi
    download_snapshot "$timestamp" "$url" "forum"
    ((forum_count++))
done < "$OUTPUT_DIR/cdx-forum.txt"

# -------------------------------------------------------------------
# Step 6: Download news snapshots (first 100)
# -------------------------------------------------------------------
echo ""
echo "[6/6] Downloading news snapshots (up to 100)..."

news_count=0
while IFS=' ' read -r timestamp url _ _ _; do
    if [[ $news_count -ge 100 ]]; then
        echo "  Reached 100 news snapshots, stopping."
        break
    fi
    download_snapshot "$timestamp" "$url" "news"
    ((news_count++))
done < "$OUTPUT_DIR/cdx-news.txt"

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "=============================================="
echo " DONE"
echo "=============================================="
echo ""
echo "CDX index:    $OUTPUT_DIR/cdx-all.txt ($total entries)"
echo "HTML 200s:    $OUTPUT_DIR/cdx-html-200.txt ($html_count entries)"
echo ""
echo "Category indexes:"
for f in "$OUTPUT_DIR"/cdx-*.txt; do
    name=$(basename "$f")
    count=$(wc -l < "$f")
    echo "  $name: $count"
done
echo ""
echo "Downloaded pages:"
for d in pages forum news; do
    count=$(find "$OUTPUT_DIR/$d" -name "*.html" 2>/dev/null | wc -l)
    echo "  $d/: $count files"
done
echo ""
echo "Next steps:"
echo "  1. Review cdx-forum.txt for forum URL patterns"
echo "  2. Run fetch-wayback-forum.sh for deep forum crawl"
echo "  3. Use extract-text.sh to strip HTML from downloads"
echo "  4. Search for specific people/topics in extracted text"
