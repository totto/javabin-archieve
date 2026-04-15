# java.no Technical Infrastructure - Detailed Findings

## 1. Technology Stack: Three Distinct Eras

### Era 1: "Cibus" Portal (~2008-2010)

Source code recovered from github.com/javaBin/cibus ("Front application of java.no")

**Full stack from pom.xml:**
- Framework: Spring Framework 2.5.6.SEC01 (beans, context, AOP, web)
- Security: Spring Security 2.0.4
- REST API: Jersey 1.1.5 (JAX-RS) with Spring integration
- View layer: JSP 2.1, SiteMesh 2.2.1 (page decoration), Tuckey URL Rewrite Filter 3.1.0
- Database: PostgreSQL 8.1 (JDBC driver), Commons DBCP 1.2.2 (connection pooling)
- Caching: EhCache 1.5.0
- RSS/Atom feeds: Rome 0.9, Apache Abdera (Atom protocol client)
- Scheduling: Quartz 1.6.1
- Email: Java Mail 1.4.1
- Config: Constretto 1.0-rc-12
- App Server: Jetty 6.1.18 (embedded)
- Build: Maven
- Package name: no.java.portal

### Era 1b: "Cibus2" CMS (~2010)

Source: github.com/javaBin/cibus2 ("LEGAZY!!!")

Replaced the CMS backend for JavaZone.no with split architecture:
- Cibus-CMS-Web: Backend HTML content repository (port 8100)
- Cibus-Web: Frontend styling layer (port 8099)
- Tech: SiteMesh 2.4.1, Tuckey URL Rewrite 3.2.0, Rome 1.0 (RSS/Atom)
- JDOM, DOM4J, Commons HttpClient 3.1
- Jetty 6.1.23, Java 1.5 target

### Era 2: Play Framework Site (~2010-2013)

Source: github.com/javaBin/javabin-hjemmeside

- Framework: Play Framework 1.2.4/1.2.5
- Database: PostgreSQL 8.1 (same old JDBC driver)
- Feed processing: Apache Abdera 1.1.2 (Atom feeds from wiki.java.no)
- Calendar: iCal4J 1.0-rc1
- HTTP: HttpCache4J 3.3
- Modules: Play PDF 0.7, Play Secure, PlayApps 1.4
- Deployment: WAR files deployed to www4.java.no
- Server: Jetty on Solaris Zones

### Era 3: Jekyll (2013-2022), then Next.js/TypeScript (2022-present)

- github.com/javaBin/java.no-2017: Jekyll (Ruby static site generator)
  JavaScript 68.2%, HTML 20.6%, SCSS 11.1%
- github.com/javaBin/java.no: Current Next.js/TypeScript on Vercel

---

## 2. Server Infrastructure

### Confirmed Hostnames
- www4.java.no - production web server (Play Framework era)
- onp.java.no - database server (PostgreSQL port 5432, accessed via SSH tunnel)
- smia.java.no - Maven repository + EMS (Event Management Suite) homepage
- wiki.java.no - self-hosted Atlassian Confluence
- lister.java.no - mailing list server
- shop.java.no - ticket sales/registration

### Operating System: Solaris 10+ with Zones

Deployment command from javabin-hjemmeside:
```
sudo zlogin zone1 svcadm restart cswjetty6:play
```

This definitively proves:
- Solaris (zlogin and svcadm are Solaris commands)
- Solaris Zones (lightweight virtualization containers)
- SMF (Service Management Facility) for service management
- Jetty registered as SMF service named cswjetty6:play

The cibus packaging module was specifically for Solaris deployment.

---

## 3. wiki.java.no - Atlassian Confluence (Self-Hosted)

Confirmed: wiki.java.no ran Atlassian Confluence. Evidence:

1. URL pattern: wiki.java.no/display/{space}/{page} is classic Confluence format
   - wiki.java.no/display/smia/Cibus
   - wiki.java.no/display/scala/Home
   - wiki.java.no/display/javabin/Bidra
   - wiki.java.no/display/javabin/Vedtekter

2. Application.java from javabin-hjemmeside fetches news from:
   ```
   http://wiki.java.no/createrssfeed.action?types=blogpost&sort=created
   &showContent=true&spaces=javabin&labelString=forside&rssType=atom
   &maxResults=10&timeSpan=5&publicFeed=true&title=javaBin+RSS+Feed
   ```
   The createrssfeed.action endpoint and parameters are Confluence-specific.

3. Known Confluence spaces:
   - javabin - main javaBin space (blog posts labeled "forside" for homepage)
   - smia - development tools space (Cibus docs, EMS docs)
   - scala - scalaBin (Scala user group)
   - javazone - JavaZone content

4. wiki.java.no still resolves but is behind authentication.
5. Later migrated to Atlassian Cloud at javabin.atlassian.net (still active).

---

## 4. The Forum - Growth Metrics

From indexed SlidePlayer/SlideServe presentations:

- ~2004-2005: Over 1,300 messages posted in a year
- ~2004-2005: Registered users grew from 600 to 870+
- 2006: 470 registered users, 2,500 messages posted
- Forum was described as "nytt forum installert pa www.java.no" (new forum
  installed on www.java.no) - suggesting a forum replacement ~2004-2005

Note: Could NOT confirm Jive Forums specifically from source code. Given the
Java-based tech stack and the era (2003-2005), Jive Forums (last free as
v1.2.4) would have been natural, but no direct proof was found. The Confluence
blog system served as the news/content system, not the forum.

---

## 5. Mailing Lists

- lister.java.no - mailing list server (referenced in Confluence docs)
- styret@java.no - board mailing address
- drift@java.no - operations/infrastructure team
- javazone@java.no - JavaZone contact
- president@java.no - president's role address

The javaBin/massmailer repo (Java, archived) was a bulk email utility
described as "old stuff being imported to our git repo."

---

## 6. Additional Infrastructure Systems

### LDAP Directory
javaBin ran an LDAP system for member/volunteer management.
Dedicated ldap-admin tool at github.com/javaBin/ldap-admin (2011).

### WordPress Phase
At some point news was published via WordPress.
Confirmed by javaBin/atom-2-twitter-publish (Scala) which read
WordPress Atom feeds and published titles to Twitter.

### "SMIA" Internal Project Name
SMIA was the internal tools/infrastructure project name:
- wiki.java.no/display/smia/ - tools space
- smia.java.no - Maven repository + EMS homepage
- Referenced throughout cibus and EMS repos

### Member Database
javaBin/hospes (2010, Scala/SBT/Jetty) - member database system.

---

## 7. Complete GitHub Repository Inventory (Historical)

| Repo | Created | Description |
|------|---------|-------------|
| cibus | 2010-02 | Front application of java.no (Spring/Jersey/PostgreSQL) |
| cibus2 | 2010-04 | CMS replacement for JavaZone.no |
| javabin-hjemmeside | ~2010 | java.no site on Play Framework 1.2.4 |
| java.no-2017 | 2013-03 | Jekyll-based java.no (2013-2022 era) |
| java.no | 2022-10 | Current Next.js/TypeScript site |
| ems-abandoned | 2009-06 | Event Management Suite (Restlet, smia.java.no) |
| ems-redux | ~2012 | EMS rewrite (holds all historical talks) |
| incogito | 2009-06 | JavaZone agenda planner (Jetty/Derby/Voldemort) |
| submitit | 2009-07 | Talk submission system (Scala) |
| submitit-redux | ~2013 | Talk submission rewrite |
| cake-redux | ~2013 | Program committee tool |
| sleepingPillCore | ~2016 | Current talk management system |
| ldap-admin | 2011-08 | LDAP user management |
| hospes | 2010-12 | Member database (Scala/SBT/Jetty) |
| massmailer | 2012-01 | Bulk email sender |
| atom-2-twitter-publish | 2011-02 | WordPress to Twitter bridge (Scala) |
| jz-web-archive | 2012-10 | wget mirrors of jz09-jz12.java.no |
| javazone.no | ~2017 | React JavaZone website (LEGAZY) |
| javazone-2020 | 2020 | Year-specific JavaZone site |
| javazone-2021 | 2021 | Year-specific JavaZone site |
| javazone-2022 | 2022 | Year-specific JavaZone site |
| 2024.javazone.no | 2024 | JavaZone 2024 (Astro) |
| vedtekter | - | Bylaws in Markdown (version controlled) |
| docs | - | Organization overview |

Also relevant forks:
- esschul/javabin-hjemmeside - fork with wiki.java.no integration code
- arktekk/atom-client - AtomPub client with wiki.java.no test data

---

## 8. Sources

- github.com/javaBin/cibus - Cibus portal source code
- github.com/javaBin/cibus2 - Cibus2 CMS source
- github.com/javaBin/javabin-hjemmeside - Play Framework java.no
- github.com/javaBin/java.no-2017 - Jekyll java.no
- github.com/esschul/javabin-hjemmeside - Fork with wiki.java.no feeds
- github.com/javaBin/ldap-admin - LDAP management
- github.com/javaBin/hospes - Member database
- github.com/javaBin/massmailer - Email sender
- github.com/javaBin/atom-2-twitter-publish - WordPress to Twitter
- slideplayer.no/slide/2147269/ - Totto "Det norske javamiljo" (indexed)
- slideplayer.no/slide/2147256/ - Arsmotet 2006 (indexed)
