#!/usr/bin/env bash
#
# fetch-github-repos.sh - Clone all historical javaBin GitHub repos
#
# These repos contain the actual source code and infrastructure for
# java.no, JavaZone, and javaBin's internal systems.
#
set -euo pipefail

OUTPUT_DIR="github-repos"
mkdir -p "$OUTPUT_DIR"

echo "=============================================="
echo " javaBin Historical GitHub Repo Cloner"
echo "=============================================="

clone_repo() {
    local repo="$1"
    local desc="$2"
    local dir="$OUTPUT_DIR/$repo"

    if [[ -d "$dir/.git" ]]; then
        echo "  SKIP (exists): $repo"
        return
    fi

    echo "  CLONE: javaBin/$repo - $desc"
    git clone --depth 1 "https://github.com/javaBin/${repo}.git" "$dir" 2>/dev/null || {
        echo "    WARN: Failed to clone $repo"
        return
    }
}

echo ""
echo "--- java.no Website (all eras) ---"
clone_repo "cibus" "java.no portal ~2008-2010 (Spring/Jersey/PostgreSQL)"
clone_repo "cibus2" "JavaZone.no CMS ~2010 (LEGAZY)"
clone_repo "javabin-hjemmeside" "java.no ~2010-2013 (Play Framework)"
clone_repo "java.no-2017" "java.no 2013-2022 (Jekyll)"
clone_repo "java.no" "java.no 2022+ (Next.js/TypeScript)"

echo ""
echo "--- JavaZone Conference Systems ---"
clone_repo "ems-abandoned" "Event Management Suite v1 (Restlet/Java)"
clone_repo "ems-redux" "EMS v2 - ALL historical talks"
clone_repo "sleepingPillCore" "Current talk management system"
clone_repo "submitit" "Talk submission (Scala)"
clone_repo "submitit-redux" "Talk submission rewrite"
clone_repo "cake-redux" "Program committee evaluation tool"
clone_repo "javazone-web-api" "Backend API for javazone.no"

echo ""
echo "--- JavaZone Websites ---"
clone_repo "jz-web-archive" "wget mirrors of jz09-jz12.java.no"
clone_repo "javazone.no" "React JavaZone website ~2018 (LEGAZY)"
clone_repo "javazone-2020" "JavaZone 2020 website"
clone_repo "javazone-2021" "JavaZone 2021 website"
clone_repo "javazone-2022" "JavaZone 2022 website"
clone_repo "2024.javazone.no" "JavaZone 2024 (Astro)"

echo ""
echo "--- Infrastructure & Member Systems ---"
clone_repo "ldap-admin" "LDAP user/volunteer management"
clone_repo "hospes" "Member database (Scala)"
clone_repo "massmailer" "Bulk email sender"
clone_repo "atom-2-twitter-publish" "WordPress Atom to Twitter bridge"
clone_repo "incogito" "JavaZone agenda planner"

echo ""
echo "--- Governance ---"
clone_repo "vedtekter" "Bylaws/statutes in Markdown"
clone_repo "docs" "Organization overview"

echo ""
echo "=============================================="
echo " DONE"
echo "=============================================="
echo ""
echo "Repos cloned:"
find "$OUTPUT_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l | xargs echo " "
echo ""
echo "Total size:"
du -sh "$OUTPUT_DIR"
echo ""
echo "Key files to examine:"
echo "  github-repos/cibus/pom.xml - Full tech stack of java.no portal"
echo "  github-repos/javabin-hjemmeside/conf/application.conf - Play config"
echo "  github-repos/jz-web-archive/jz09.java.no/ - 2009 website snapshot"
echo "  github-repos/ems-redux/ - Historical JavaZone talk data"
echo "  github-repos/vedtekter/Vedtekter.md - Official bylaws"
echo "  github-repos/cibus/src/main/resources/ - DB config, server hostnames"
