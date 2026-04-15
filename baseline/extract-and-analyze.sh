#!/usr/bin/env bash
#
# extract-and-analyze.sh - Extract text and build analysis from downloaded content
#
# Run AFTER fetch-wayback.sh and fetch-secondary-sources.sh
# Produces a consolidated report of all findings.
#
set -euo pipefail

WAYBACK_DIR="wayback-output"
SECONDARY_DIR="secondary-sources"
ANALYSIS_DIR="analysis"

mkdir -p "$ANALYSIS_DIR"

echo "=============================================="
echo " java.no Content Analysis"
echo "=============================================="

# -------------------------------------------------------------------
# Helper: extract text from HTML using Python
# -------------------------------------------------------------------
extract_text() {
    python3 -c "
import html.parser, sys, re

class TextExtractor(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.result = []
        self.skip = False
        self.skip_tags = {'script', 'style', 'noscript', 'header', 'footer', 'nav'}

    def handle_starttag(self, tag, attrs):
        if tag in self.skip_tags:
            self.skip = True
        if tag in ('br', 'p', 'div', 'li', 'tr', 'h1', 'h2', 'h3', 'h4', 'td', 'th'):
            self.result.append('\n')

    def handle_endtag(self, tag):
        if tag in self.skip_tags:
            self.skip = False

    def handle_data(self, data):
        if not self.skip:
            self.result.append(data.strip())

with open(sys.argv[1], 'r', errors='ignore') as f:
    content = f.read()

# Remove Wayback toolbar
content = re.sub(r'<!-- BEGIN WAYBACK TOOLBAR.*?END WAYBACK TOOLBAR INSERT -->', '', content, flags=re.DOTALL)
content = re.sub(r'<script[^>]*wombat[^>]*>.*?</script>', '', content, flags=re.DOTALL)

extractor = TextExtractor()
extractor.feed(content)
text = ' '.join(extractor.result)
text = re.sub(r'\s+', ' ', text)
text = re.sub(r'\n{3,}', '\n\n', text)
print(text.strip())
" "$1" 2>/dev/null || echo "(extraction failed)"
}

# -------------------------------------------------------------------
# Step 1: Extract text from all secondary sources
# -------------------------------------------------------------------
echo ""
echo "[1/4] Extracting text from secondary sources..."

mkdir -p "$ANALYSIS_DIR/extracted"
for html_file in "$SECONDARY_DIR"/{slides,blogs,documents}/*.html; do
    [[ -f "$html_file" ]] || continue
    base=$(basename "$html_file" .html)
    txt_file="$ANALYSIS_DIR/extracted/${base}.txt"
    if [[ ! -f "$txt_file" ]]; then
        extract_text "$html_file" > "$txt_file"
        echo "  Extracted: $base"
    fi
done

# -------------------------------------------------------------------
# Step 2: Build people index
# -------------------------------------------------------------------
echo ""
echo "[2/4] Building people index..."

{
    echo "# People Index - java.no / javaBin"
    echo "# Generated $(date -I)"
    echo ""
    echo "Searching all extracted content for known names..."
    echo ""

    declare -A PEOPLE_MAP
    PEOPLE_MAP=(
        ["Thor Henning Hetland"]="President 1998-2008, ObjectWare"
        ["Totto"]="Nickname for Thor Henning Hetland"
        ["Stein Grimstad"]="Vice President, early 2000s-2007"
        ["Carl Onstad"]="Key organizer, JavaZone sponsors"
        ["Bjorn Tveiten"]="Finance Officer"
        ["Bjørn Tveiten"]="Finance Officer"
        ["Kaare Knudsen"]="Deputy Chair"
        ["Olve Maudal"]="Board member, speaker"
        ["Kjetil Jorgensen-Dahl"]="Board member, ObjectNet"
        ["Kjetil Jørgensen-Dahl"]="Board member, ObjectNet"
        ["Odd Erik Zapffe"]="Board member, Mesan"
        ["Oyvind Lokling"]="Board member, WM-Data"
        ["Øyvind Løkling"]="Board member, WM-Data"
        ["Harald Kuhr"]="Board member, WM-Data"
        ["Leif Jantzen"]="Board member"
        ["Thomas Oldervoll"]="Board member"
        ["Lennart Alvestad"]="Board member"
        ["Maja Bratseth"]="Board member"
        ["Laila Ronning"]="Board member"
        ["Laila Rønning"]="Board member"
        ["Ole-Martin Mork"]="Board member"
        ["Ole-Martin Mørk"]="Board member"
        ["Kjetil Valstadsve"]="Board member"
        ["Nils Christian Haugen"]="Board member"
        ["Trond Stromme"]="Board member"
        ["Trond Strømme"]="Board member"
        ["Bjorn Bjerkeli"]="Board member 2005+"
        ["Bjørn Bjerkeli"]="Board member 2005+"
        ["Andreas Bade"]="Board member 2005+"
        ["Tobias Torrissen"]="Board member 2005+"
        ["Nils Helge Garli"]="Board member 2005+"
        ["Dervis Mansuroglu"]="Board 2014+, Java Champion"
        ["Rustam Mehmandarov"]="JavaZone leader, Java Champion"
        ["Markus Kruger"]="Oslo meetups 2014+"
        ["Markus Krüger"]="Oslo meetups 2014+"
        ["Helge Skrivervik"]="1996 founding, Skrivervik Data"
    )

    all_text_dirs=("$ANALYSIS_DIR/extracted")
    [[ -d "$WAYBACK_DIR/extracted" ]] && all_text_dirs+=("$WAYBACK_DIR/extracted")

    for person in "${!PEOPLE_MAP[@]}"; do
        hits=0
        for dir in "${all_text_dirs[@]}"; do
            dir_hits=$(grep -ril "$person" "$dir" 2>/dev/null | wc -l || true)
            hits=$((hits + dir_hits))
        done
        if [[ $hits -gt 0 ]]; then
            echo "[$hits mentions] $person - ${PEOPLE_MAP[$person]}"
            for dir in "${all_text_dirs[@]}"; do
                grep -ril "$person" "$dir" 2>/dev/null | head -3 | sed 's/^/  -> /'
            done
            echo ""
        fi
    done
} > "$ANALYSIS_DIR/people-index.txt"

echo "  Saved: $ANALYSIS_DIR/people-index.txt"

# -------------------------------------------------------------------
# Step 3: Build timeline from content
# -------------------------------------------------------------------
echo ""
echo "[3/4] Building timeline..."

{
    echo "# java.no / javaBin Timeline"
    echo "# Generated $(date -I)"
    echo ""

    YEARS=(1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010)

    for year in "${YEARS[@]}"; do
        echo "=== $year ==="
        # Search for year mentions in context
        for dir in "${all_text_dirs[@]}"; do
            grep -r "$year" "$dir" 2>/dev/null \
                | grep -iE "java|javazone|javabin|møte|meeting|konferanse|conference|styre|board" \
                | head -5 \
                | sed 's/^/  /'
        done
        echo ""
    done
} > "$ANALYSIS_DIR/timeline.txt"

echo "  Saved: $ANALYSIS_DIR/timeline.txt"

# -------------------------------------------------------------------
# Step 4: Generate consolidated report
# -------------------------------------------------------------------
echo ""
echo "[4/4] Generating consolidated report..."

{
    echo "# java.no / javaBin - Consolidated Analysis Report"
    echo "# Generated $(date -I)"
    echo ""
    echo "## Files Analyzed"
    echo ""
    find "$ANALYSIS_DIR/extracted" -name "*.txt" -type f | sort | while read -r f; do
        size=$(wc -c < "$f")
        echo "  $(basename "$f"): ${size} bytes"
    done

    if [[ -d "$WAYBACK_DIR/extracted" ]]; then
        echo ""
        echo "## Wayback Machine Content"
        for subdir in pages forum forum-threads news; do
            dir="$WAYBACK_DIR/extracted/$subdir"
            [[ -d "$dir" ]] || continue
            count=$(find "$dir" -name "*.txt" -type f | wc -l)
            echo "  $subdir/: $count text files"
        done
    fi

    echo ""
    echo "## Key Findings"
    echo ""
    echo "### People Index"
    cat "$ANALYSIS_DIR/people-index.txt" 2>/dev/null | head -100

    echo ""
    echo "### URL Structure (from Wayback)"
    cat "$WAYBACK_DIR/forum-deep/url-structure.txt" 2>/dev/null | head -30

} > "$ANALYSIS_DIR/consolidated-report.txt"

echo "  Saved: $ANALYSIS_DIR/consolidated-report.txt"

echo ""
echo "=============================================="
echo " ANALYSIS COMPLETE"
echo "=============================================="
echo ""
echo "Output: $ANALYSIS_DIR/"
find "$ANALYSIS_DIR" -type f | sort | sed 's/^/  /'
