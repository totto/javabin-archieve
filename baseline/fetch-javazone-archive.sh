#!/usr/bin/env bash
#
# fetch-javazone-archive.sh - Fetch JavaZone historical data from GitHub and APIs
#
# Clones the jz-web-archive repo and queries EMS/SleepingPill for historical talks.
#
set -euo pipefail

OUTPUT_DIR="javazone-archive"
mkdir -p "$OUTPUT_DIR"/{web-archive,ems-data,year-sites,vimeo-index}

echo "=============================================="
echo " JavaZone Historical Archive Fetcher"
echo "=============================================="

# -------------------------------------------------------------------
# Step 1: Clone the jz-web-archive repo (2009-2012 websites)
# -------------------------------------------------------------------
echo ""
echo "[1/5] Cloning jz-web-archive..."

if [[ ! -d "$OUTPUT_DIR/web-archive/.git" ]]; then
    git clone --depth 1 https://github.com/javaBin/jz-web-archive.git \
        "$OUTPUT_DIR/web-archive" 2>/dev/null || echo "WARN: Failed to clone"
else
    echo "  Already cloned, skipping."
fi

# -------------------------------------------------------------------
# Step 2: Clone EMS-redux (historical talk database)
# -------------------------------------------------------------------
echo ""
echo "[2/5] Cloning ems-redux (historical talks database)..."

if [[ ! -d "$OUTPUT_DIR/ems-data/ems-redux/.git" ]]; then
    git clone --depth 1 https://github.com/javaBin/ems-redux.git \
        "$OUTPUT_DIR/ems-data/ems-redux" 2>/dev/null || echo "WARN: Failed to clone"
else
    echo "  Already cloned, skipping."
fi

# Also try ems-abandoned for older data
if [[ ! -d "$OUTPUT_DIR/ems-data/ems-abandoned/.git" ]]; then
    git clone --depth 1 https://github.com/javaBin/ems-abandoned.git \
        "$OUTPUT_DIR/ems-data/ems-abandoned" 2>/dev/null || echo "WARN: Failed to clone"
else
    echo "  Already cloned, skipping."
fi

# -------------------------------------------------------------------
# Step 3: Try fetching from SleepingPill API
# -------------------------------------------------------------------
echo ""
echo "[3/5] Querying SleepingPill/EMS APIs for historical talk data..."

# Try known API endpoints
APIS=(
    "https://sleepingpill.javazone.no/public/allSessions"
    "https://sleepingpill.javazone.no/public/conferences"
    "https://sleepingpill.javazone.no/data/conference"
)

for api in "${APIS[@]}"; do
    safe_name=$(echo "$api" | sed 's|https\?://||; s|/|_|g')
    outfile="$OUTPUT_DIR/ems-data/${safe_name}.json"
    echo "  Trying: $api"
    curl -s -f -L --max-time 30 \
        -H "Accept: application/json" \
        -o "$outfile" "$api" 2>/dev/null && {
        size=$(wc -c < "$outfile")
        echo "    OK: $size bytes"
    } || {
        echo "    FAIL"
        rm -f "$outfile"
    }
    sleep 1
done

# -------------------------------------------------------------------
# Step 4: Fetch year-specific JavaZone sites
# -------------------------------------------------------------------
echo ""
echo "[4/5] Checking year-specific JavaZone sites..."

for year in $(seq 2002 2024); do
    url="https://${year}.javazone.no/"
    echo -n "  ${year}.javazone.no: "
    status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
    echo "$status"

    if [[ "$status" == "200" ]]; then
        # Try to get the about/program page
        for path in "" "about" "aboutUs" "program" "speakers" "info"; do
            page_url="${url}${path}"
            safe_name="${year}_${path:-index}"
            outfile="$OUTPUT_DIR/year-sites/${safe_name}.html"
            curl -s -f -L --max-time 15 -o "$outfile" "$page_url" 2>/dev/null || rm -f "$outfile"
        done
    fi
    sleep 0.5
done

# -------------------------------------------------------------------
# Step 5: Index Vimeo videos
# -------------------------------------------------------------------
echo ""
echo "[5/5] Fetching Vimeo video index (if yt-dlp available)..."

if command -v yt-dlp &>/dev/null; then
    echo "  Fetching video list from Vimeo (metadata only)..."
    yt-dlp --flat-playlist --print "%(upload_date)s %(title)s %(id)s" \
        "https://vimeo.com/javazone" \
        > "$OUTPUT_DIR/vimeo-index/javazone-videos.txt" 2>/dev/null || {
        echo "  WARN: yt-dlp failed, trying alternative..."
    }
else
    echo "  yt-dlp not found. Install it to index Vimeo videos."
    echo "  Manual URL: https://vimeo.com/javazone/videos"
fi

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "=============================================="
echo " ARCHIVE FETCH COMPLETE"
echo "=============================================="
echo ""
echo "Output: $OUTPUT_DIR/"
for d in web-archive ems-data year-sites vimeo-index; do
    count=$(find "$OUTPUT_DIR/$d" -type f 2>/dev/null | wc -l)
    echo "  $d/: $count files"
done
echo ""
echo "Key files to examine:"
echo "  web-archive/jz09.java.no/about-javazone/backstory/ - Official history"
echo "  web-archive/jz09.java.no/about-javazone/crew/ - 2009 crew/team"
echo "  web-archive/jz09.java.no/about-javazone/organiser/ - Organizers"
echo "  ems-data/*.json - Historical talk data from SleepingPill"
echo "  year-sites/ - Archived year-specific sites"
