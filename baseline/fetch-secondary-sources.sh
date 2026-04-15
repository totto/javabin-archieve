#!/usr/bin/env bash
#
# fetch-secondary-sources.sh - Download known secondary sources about java.no history
#
# These are documents we know exist from web searches but couldn't access
# from the restricted environment. Run from an unrestricted network.
#
set -euo pipefail

OUTPUT_DIR="secondary-sources"
DELAY=2

mkdir -p "$OUTPUT_DIR"/{slides,blogs,documents,videos}

echo "=============================================="
echo " java.no Secondary Source Fetcher"
echo "=============================================="

download() {
    local url="$1"
    local outfile="$2"
    local desc="$3"

    if [[ -f "$outfile" ]]; then
        echo "  SKIP (exists): $desc"
        return
    fi

    echo "  GET: $desc"
    echo "       $url"
    curl -s -f -L --max-time 60 -o "$outfile" "$url" 2>/dev/null || {
        echo "       WARN: Failed to download"
        rm -f "$outfile"
    }
    sleep "$DELAY"
}

echo ""
echo "--- Annual Meeting Presentations ---"

download "https://docplayer.me/3709172-Javabin-arsmote-5-februar-2003-arsmote.html" \
    "$OUTPUT_DIR/documents/javabin-arsmotet-2003-02-05.html" \
    "javaBin Annual Meeting Feb 5, 2003"

download "http://docplayer.me/13999056-Javabin-mote-2004-2-5.html" \
    "$OUTPUT_DIR/documents/javabin-mote-2004.html" \
    "javaBin Meeting 2004"

echo ""
echo "--- Slide Presentations ---"

# These are slideplayer.no pages - we download the HTML which embeds the slides
download "https://slideplayer.no/slide/2147256/" \
    "$OUTPUT_DIR/slides/javabin-arsmotet-2006.html" \
    "javaBin Annual Meeting 2006 (Slides)"

download "https://slideplayer.no/slide/2147246/" \
    "$OUTPUT_DIR/slides/javabin-arsmotet-2008.html" \
    "javaBin Annual Meeting April 17, 2008 (Slides)"

download "https://slideplayer.no/slide/2147269/" \
    "$OUTPUT_DIR/slides/totto-det-norske-javamiljo.html" \
    "Totto: Det norske javamiljo (Slides)"

download "https://www.slideserve.com/mala/javabin" \
    "$OUTPUT_DIR/slides/javabin-slideserve.html" \
    "javaBin Presentation (SlideServe)"

download "https://cupdf.com/document/javabin-arsmote-2007.html" \
    "$OUTPUT_DIR/slides/javabin-arsmotet-2007.html" \
    "javaBin Annual Meeting 2007"

download "https://slideplayer.com/slide/2036034/" \
    "$OUTPUT_DIR/slides/totto-mads-soa-2007.html" \
    "Totto & Mads: SOA Presentation 2007"

echo ""
echo "--- Blog Posts ---"

download "http://olvemaudal.com/2007/09/15/javazone-2007-and-a-tribute-to-totto-and-stein/" \
    "$OUTPUT_DIR/blogs/olve-maudal-tribute-totto-stein-2007.html" \
    "Olve Maudal: JavaZone 2007 tribute to Totto and Stein"

download "https://olvemaudal.wordpress.com/2008/04/30/the-software-development-community-in-oslo/" \
    "$OUTPUT_DIR/blogs/olve-maudal-oslo-community-2008.html" \
    "Olve Maudal: Software Development Community in Oslo"

download "http://olvemaudal.com/2008/09/25/javazone-where-to-go-next/" \
    "$OUTPUT_DIR/blogs/olve-maudal-javazone-where-to-go-next.html" \
    "Olve Maudal: JavaZone - Where to go next?"

download "https://jimgrisanzio.wordpress.com/2024/02/14/dervis-mansuroglu-dreaming-big-with-java/" \
    "$OUTPUT_DIR/blogs/dervis-dreaming-big-with-java.html" \
    "Dervis Mansuroglu: Dreaming Big with Java"

download "https://www.dervis.no/blog/2024-08-15-my-journey/" \
    "$OUTPUT_DIR/blogs/dervis-my-journey-java-community.html" \
    "Dervis: My journey as part of the Java community"

download "https://www.dervis.no/about/" \
    "$OUTPUT_DIR/blogs/dervis-about.html" \
    "Dervis Mansuroglu: About page"

echo ""
echo "--- Organization Info ---"

download "https://java.no/en" \
    "$OUTPUT_DIR/documents/java-no-current.html" \
    "java.no current website"

download "https://java.no/en/principles" \
    "$OUTPUT_DIR/documents/java-no-principles.html" \
    "javaBin principles/vedtekter"

download "https://java.no/en/policy" \
    "$OUTPUT_DIR/documents/java-no-policy.html" \
    "javaBin policy"

download "https://b2bhint.com/en/company/no/java-brukerforening-i-norge--985842655" \
    "$OUTPUT_DIR/documents/bronnysund-registry.html" \
    "Business registry entry (org.nr 985842655)"

echo ""
echo "--- Reference Pages ---"

download "https://www.cafeaulait.org/usergroups.html" \
    "$OUTPUT_DIR/documents/cafe-au-lait-user-groups.html" \
    "Cafe au Lait Java User Groups listing"

download "https://anydayguide.com/festival/2547-javazone" \
    "$OUTPUT_DIR/documents/anydayguide-javazone.html" \
    "AnyDayGuide: JavaZone history"

download "https://2023.javazone.no/about" \
    "$OUTPUT_DIR/documents/javazone-2023-about.html" \
    "JavaZone 2023 About page"

download "https://2024.javazone.no/aboutUs" \
    "$OUTPUT_DIR/documents/javazone-2024-about.html" \
    "JavaZone 2024 About page"

echo ""
echo "--- GitHub ---"

download "https://raw.githubusercontent.com/javaBin/docs/main/README.md" \
    "$OUTPUT_DIR/documents/javabin-docs-readme.md" \
    "javaBin docs README"

download "https://raw.githubusercontent.com/javaBin/java.no/main/README.md" \
    "$OUTPUT_DIR/documents/java-no-readme.md" \
    "java.no repo README"

echo ""
echo "--- Video References (metadata only) ---"

cat > "$OUTPUT_DIR/videos/video-links.txt" << 'VIDEOEOF'
# Video sources about javaBin history
# Download these manually or use yt-dlp

# Totto: Running One of the Biggest JUGs (TSS Tech Brief)
# ~2007, interview about running javaBin and JavaZone
https://www.dailymotion.com/video/x3aj6x

# TheServerSide discussion thread about the video
https://www.theserverside.com/discussions/thread/47331.html

# JavaZone historical videos are on Vimeo
# Search: https://vimeo.com/search?q=javazone
VIDEOEOF

echo "  Saved video reference links"

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "=============================================="
echo " SECONDARY SOURCES COMPLETE"
echo "=============================================="
echo ""
find "$OUTPUT_DIR" -type f | wc -l | xargs -I{} echo "Total files: {}"
du -sh "$OUTPUT_DIR" | awk '{print "Total size: " $1}'
echo ""
echo "Directory: $OUTPUT_DIR/"
for d in slides blogs documents videos; do
    count=$(find "$OUTPUT_DIR/$d" -type f | wc -l)
    echo "  $d/: $count files"
done
