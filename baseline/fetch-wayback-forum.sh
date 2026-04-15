#!/usr/bin/env bash
#
# fetch-wayback-forum.sh - Deep crawl of java.no forum content from Wayback
#
# Run AFTER fetch-wayback.sh (needs cdx-all.txt).
# Tries multiple URL patterns to find the forum content.
#
set -euo pipefail

OUTPUT_DIR="wayback-output"
CDX_API="https://web.archive.org/cdx/search/cdx"
WAYBACK="https://web.archive.org/web"
DELAY=1
FROM_YEAR=${1:-1996}
TO_YEAR=${2:-2010}

mkdir -p "$OUTPUT_DIR"/{forum-deep,forum-threads,forum-users,extracted}

echo "=============================================="
echo " java.no Forum Deep Crawl"
echo " Period: $FROM_YEAR - $TO_YEAR"
echo "=============================================="

# -------------------------------------------------------------------
# Step 1: Try common Java forum URL patterns against CDX
# -------------------------------------------------------------------
echo ""
echo "[1/5] Probing forum URL patterns..."

# java.no likely used Jive Forums, JForum, or a custom Java solution.
# Common URL patterns for these:
FORUM_PATTERNS=(
    "java.no/jive/*"
    "java.no/forum/*"
    "java.no/forums/*"
    "java.no/thread/*"
    "java.no/threads/*"
    "java.no/discussion/*"
    "java.no/diskusjon/*"
    "java.no/message/*"
    "java.no/messages/*"
    "java.no/topic/*"
    "java.no/topics/*"
    "java.no/post/*"
    "java.no/posts/*"
    "java.no/community/*"
    "java.no/servlet/*"
    "java.no/jforum/*"
    "www.java.no/jive/*"
    "www.java.no/forum/*"
    "www.java.no/forums/*"
    "www.java.no/thread/*"
    "www.java.no/discussion/*"
    "www.java.no/diskusjon/*"
    "www.java.no/community/*"
    "www.java.no/servlet/*"
    "www.java.no/jforum/*"
)

for pattern in "${FORUM_PATTERNS[@]}"; do
    safe_name=$(echo "$pattern" | tr '/*' '_-')
    outfile="$OUTPUT_DIR/forum-deep/probe-${safe_name}.txt"
    count=$(curl -s -f \
        "${CDX_API}?url=${pattern}&output=text&fl=timestamp,original,statuscode&from=${FROM_YEAR}&to=${TO_YEAR}&limit=5" \
        2>/dev/null | wc -l || echo 0)
    if [[ "$count" -gt 0 ]]; then
        echo "  HIT: $pattern -> $count+ results"
        # Fetch full listing for hits
        curl -s -f \
            "${CDX_API}?url=${pattern}&output=text&fl=timestamp,original,mimetype,statuscode,length&from=${FROM_YEAR}&to=${TO_YEAR}&limit=5000" \
            -o "$outfile" 2>/dev/null || true
        hit_count=$(wc -l < "$outfile" 2>/dev/null || echo 0)
        echo "       Full listing: $hit_count entries -> $outfile"
    else
        echo "  MISS: $pattern"
    fi
    sleep "$DELAY"
done

# -------------------------------------------------------------------
# Step 2: Analyze URL structure from CDX data
# -------------------------------------------------------------------
echo ""
echo "[2/5] Analyzing URL structure from CDX data..."

if [[ -f "$OUTPUT_DIR/cdx-all.txt" ]]; then
    echo "  Top 30 URL path prefixes:"
    awk '{print $2}' "$OUTPUT_DIR/cdx-all.txt" \
        | sed 's|https\?://[^/]*/||; s|/[^/]*$|/|; s|?.*||' \
        | sort | uniq -c | sort -rn | head -30 \
        | tee "$OUTPUT_DIR/forum-deep/url-structure.txt"
else
    echo "  WARN: cdx-all.txt not found. Run fetch-wayback.sh first."
fi

# -------------------------------------------------------------------
# Step 3: Download forum thread pages
# -------------------------------------------------------------------
echo ""
echo "[3/5] Downloading forum threads..."

# Merge all probe hits
cat "$OUTPUT_DIR"/forum-deep/probe-*.txt 2>/dev/null \
    | grep "text/html" | grep " 200" | sort -u \
    > "$OUTPUT_DIR/forum-deep/all-forum-urls.txt" 2>/dev/null || true

forum_total=$(wc -l < "$OUTPUT_DIR/forum-deep/all-forum-urls.txt" 2>/dev/null || echo 0)
echo "  Total forum URLs found: $forum_total"

thread_count=0
max_threads=500
while IFS=' ' read -r timestamp url _ _ _; do
    if [[ $thread_count -ge $max_threads ]]; then
        echo "  Reached $max_threads thread downloads, stopping."
        break
    fi

    safe_url=$(echo "$url" | sed 's|https\?://||; s|/|__|g; s|[^a-zA-Z0-9._-]|_|g')
    outfile="$OUTPUT_DIR/forum-threads/${timestamp}__${safe_url}.html"

    if [[ -f "$outfile" ]]; then
        continue
    fi

    wayback_url="${WAYBACK}/${timestamp}id_/${url}"
    curl -s -f -L --max-time 30 -o "$outfile" "$wayback_url" 2>/dev/null || {
        rm -f "$outfile"
        continue
    }
    ((thread_count++))
    sleep "$DELAY"
done < "$OUTPUT_DIR/forum-deep/all-forum-urls.txt"

echo "  Downloaded: $thread_count forum pages"

# -------------------------------------------------------------------
# Step 4: Extract text from HTML (strip tags, scripts, styles)
# -------------------------------------------------------------------
echo ""
echo "[4/5] Extracting text from downloaded HTML..."

extract_text() {
    local html_file="$1"
    local txt_file="$2"

    # Use Python if available, fall back to sed
    if command -v python3 &>/dev/null; then
        python3 -c "
import html.parser, sys, re

class TextExtractor(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.result = []
        self.skip = False
        self.skip_tags = {'script', 'style', 'noscript'}

    def handle_starttag(self, tag, attrs):
        if tag in self.skip_tags:
            self.skip = True
        if tag in ('br', 'p', 'div', 'li', 'tr', 'h1', 'h2', 'h3', 'h4'):
            self.result.append('\n')

    def handle_endtag(self, tag):
        if tag in self.skip_tags:
            self.skip = False

    def handle_data(self, data):
        if not self.skip:
            self.result.append(data)

with open(sys.argv[1], 'r', errors='ignore') as f:
    content = f.read()

# Remove Wayback Machine toolbar injection
content = re.sub(r'<!-- BEGIN WAYBACK TOOLBAR.*?END WAYBACK TOOLBAR INSERT -->', '', content, flags=re.DOTALL)

extractor = TextExtractor()
extractor.feed(content)
text = ''.join(extractor.result)
# Collapse whitespace
text = re.sub(r'\n{3,}', '\n\n', text)
text = re.sub(r'[ \t]+', ' ', text)
print(text.strip())
" "$html_file" > "$txt_file" 2>/dev/null
    else
        # Fallback: crude sed-based extraction
        sed 's/<script[^>]*>.*<\/script>//g; s/<style[^>]*>.*<\/style>//g; s/<[^>]*>//g' \
            "$html_file" > "$txt_file" 2>/dev/null
    fi
}

for dir in pages forum forum-threads news; do
    mkdir -p "$OUTPUT_DIR/extracted/$dir"
    count=0
    for html_file in "$OUTPUT_DIR/$dir"/*.html; do
        [[ -f "$html_file" ]] || continue
        base=$(basename "$html_file" .html)
        txt_file="$OUTPUT_DIR/extracted/$dir/${base}.txt"
        if [[ ! -f "$txt_file" ]]; then
            extract_text "$html_file" "$txt_file"
            ((count++))
        fi
    done
    echo "  Extracted $count files from $dir/"
done

# -------------------------------------------------------------------
# Step 5: Search extracted text for people and topics
# -------------------------------------------------------------------
echo ""
echo "[5/5] Searching extracted text for known people and topics..."

KNOWN_PEOPLE=(
    "Totto" "Thor Henning" "Hetland"
    "Stein Grimstad" "Carl Onstad"
    "Bjorn Tveiten" "Bjørn Tveiten"
    "Kaare Knudsen" "Olve Maudal"
    "Kjetil Jorgensen" "Kjetil Jørgensen"
    "Odd Erik Zapffe" "Oyvind Lokling" "Øyvind Løkling"
    "Harald Kuhr" "Leif Jantzen"
    "Thomas Oldervoll" "Lennart Alvestad"
    "Maja Bratseth" "Laila Ronning" "Laila Rønning"
    "Ole-Martin" "Kjetil Valstadsve"
    "Nils Christian Haugen"
    "ObjectWare" "ObjectNet" "Mesan" "WM-Data"
    "Mogul" "CGEY" "Capgemini" "Bekk"
)

TOPICS=(
    "EJB" "J2EE" "Spring" "Struts" "Hibernate"
    "JSF" "Tapestry" "JBoss" "WebLogic" "WebSphere"
    "IntelliJ" "Eclipse" "NetBeans"
    "JavaZone" "Chateau Neuf"
    "Sun Microsystems" "styre" "board" "president"
    "forum" "diskusjon"
)

{
    echo "=== PEOPLE MENTIONS ==="
    echo ""
    for person in "${KNOWN_PEOPLE[@]}"; do
        hits=$(grep -ril "$person" "$OUTPUT_DIR/extracted/" 2>/dev/null | wc -l || echo 0)
        if [[ "$hits" -gt 0 ]]; then
            echo "  $person: $hits files"
            grep -ril "$person" "$OUTPUT_DIR/extracted/" 2>/dev/null | head -5 | sed 's/^/    /'
        fi
    done

    echo ""
    echo "=== TOPIC MENTIONS ==="
    echo ""
    for topic in "${TOPICS[@]}"; do
        hits=$(grep -ril "$topic" "$OUTPUT_DIR/extracted/" 2>/dev/null | wc -l || echo 0)
        if [[ "$hits" -gt 0 ]]; then
            echo "  $topic: $hits files"
        fi
    done
} | tee "$OUTPUT_DIR/search-results.txt"

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "=============================================="
echo " FORUM CRAWL COMPLETE"
echo "=============================================="
echo ""
echo "Forum URLs found:     $forum_total"
echo "Threads downloaded:   $thread_count"
echo ""
echo "Output structure:"
echo "  $OUTPUT_DIR/"
echo "    forum-deep/         - CDX probe results and URL analysis"
echo "    forum-threads/      - Raw HTML forum pages"
echo "    extracted/          - Plain text extracted from HTML"
echo "    search-results.txt  - People and topic search results"
echo ""
echo "Suggested next steps:"
echo "  1. Review extracted/forum-threads/ for actual forum content"
echo "  2. grep for specific usernames or topics"
echo "  3. Look for thread IDs in URLs to map discussion threads"
echo "  4. Cross-reference with known-people.csv"
