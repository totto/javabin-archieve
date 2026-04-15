# java.no (javaBin) - Early Days Baseline

This archive contains a detailed baseline of java.no from its early days,
focusing on people, postings, and the forum.

## Contents

### Documents
- `baseline-report.md` - Comprehensive narrative baseline (origins, portal, people, forum)
- `additional-findings.md` - Post-Totto leadership, vedtekter, financials, GitHub repos
- `technical-infrastructure.md` - Full tech stack: Cibus/Spring/Solaris, Confluence, forum metrics
- `known-people.csv` - 29 identified people with roles, years, companies
- `board-history.csv` - Board composition by year (2003-2016)
- `javazone-timeline.csv` - Conference growth data 2002-2024

### Fetch Scripts (run from unrestricted network)
- `fetch-wayback.sh` - Wayback Machine CDX index + quarterly snapshots
- `fetch-wayback-forum.sh` - Deep forum crawl with 24 URL pattern probes
- `fetch-secondary-sources.sh` - Download slides, blogs, documents from known URLs
- `fetch-javazone-archive.sh` - Clone jz-web-archive, query SleepingPill API
- `fetch-github-repos.sh` - Clone all 22 historical javaBin GitHub repos
- `extract-and-analyze.sh` - Text extraction + people/topic search

## Usage

Run from an unrestricted network (no proxy blocking web.archive.org):

```bash
chmod +x *.sh

# Step 1: Wayback Machine snapshots of java.no
./fetch-wayback.sh

# Step 2: Deep forum content crawl
./fetch-wayback-forum.sh

# Step 3: Download slides, blogs, annual meeting docs
./fetch-secondary-sources.sh

# Step 4: Clone javaBin GitHub repos (cibus, ems-redux, etc.)
./fetch-github-repos.sh

# Step 5: JavaZone archive + SleepingPill API
./fetch-javazone-archive.sh

# Step 6: Extract text and analyze
./extract-and-analyze.sh
```

Results saved to `wayback-output/`, `secondary-sources/`, `github-repos/`, `javazone-archive/`.

## Background

- **Organization:** javaBin (Java Brukerforeningen i Norge)
- **Org.nr:** 985842655
- **Founded:** April 23, 1998 (re-founded; first attempt summer 1996)
- **Domain:** java.no
- **Conference:** JavaZone (since 2002)
