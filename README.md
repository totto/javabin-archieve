# javabin-archive

**The Early Years — The History of javaBin (Norwegian Java User Group)**

A documentary-style static site chronicling the founding and early history of javaBin, the Norwegian Java User Group (founded April 23, 1998), and how a small community in Oslo grew JavaZone into Scandinavia's largest developer conference.

## Live Site

The site is deployed on GitHub Pages from the `docs/` folder:

**https://exoreaction.github.io/javabin-archieve/**

## Structure

```
docs/               GitHub Pages source (plain HTML + CSS)
  index.html         Single-page documentary site
  style.css          Custom CSS — no frameworks, no build step

baseline/            Research baseline: timeline, people, findings
sources/             Primary sources: firsthand accounts, tributes
snapshots/           Wayback Machine snapshots of java.no
scripts/             Fetch and research scripts
wayback-output/      Raw Wayback Machine downloads
```

## Enabling GitHub Pages

If the site is not yet live, enable it in the repository settings:

1. Go to **Settings** → **Pages**
2. Under **Source**, select **Deploy from a branch**
3. Set branch to **main** and folder to **/docs**
4. Click **Save**

The site will be live within a few minutes at the URL above.

## Content

The site covers javaBin's history from 1996 to the present, with focus on the founding era (1998–2008):

- **The Origin** — The 1996 first attempt, the 1998 founding, Totto's motivation
- **The People** — The inner circle: Totto, Stein Grimstad, Carl Onstad; key contributors
- **The Platform** — java.no as a Java web application, JForum, 2M+ hits/month
- **JavaZone** — From 350 people in a basement (2002) to 3,600 at Oslo Spektrum (2024)
- **The Community** — Forum culture, Norwegian-language tech discussion, monthly meetups
- **The Handover** — 2007: Totto and Stein step down, the next generation takes over
- **Legacy** — Teknologihuset, Duke's Choice Award 2019, 4,000 members today

## Sources

Built from primary sources including:
- Olve Maudal's 2007 tribute blog post
- Thor Henning Hetland's firsthand memories (2026)
- javaBin annual meeting documents (2003–2009)
- Wayback Machine snapshots of java.no (1997–2006)
- JavaZone web archive (jz09–jz12.java.no)

## Tech

Plain HTML + CSS. No build step, no JavaScript frameworks, no dependencies. Opens in any browser. Deploys on GitHub Pages with zero configuration beyond the settings above.

## License

See [LICENSE](LICENSE).
