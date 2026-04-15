# java.no Before Cibus (1998-2007) - The Custom Portal Era

## 1. The Early Website (1998-2002)

The java.no website was almost certainly a **custom-built Java webapp** from
the start. As a Java User Group, they would have been eating their own dogfood.
No evidence of PHP, Drupal, WordPress, or any off-the-shelf CMS was found for
this era. Likely simple Servlet/JSP on Tomcat or similar.

Founding details:
- Summer 1996: First attempt by Skrivevik, IBM, Taskon and others - faded
- April 23, 1998: Formal founding (stiftelsesmotet)
- 1999: Totto became president

## 2. The Custom Portal Growth (2002-2004)

### 2002-2003
- Portal expanded in **fall 2003** with two new channels: **RSS feeds** and **WAP** (wap.java.no)
- Registered users on java.no grew from **50 to over 430** during 2003
- 800+ members from 180+ companies

### 2004
- Growth to 2,300+ participants from 150+ companies
- Portal operating with news, articles, event invitations, presentation
  archives, and meeting minutes

## 3. The Forum Platform - CONFIRMED: JForum (heavily customized)

**Forum platform: JForum** — confirmed by Thor Henning Hetland (Totto), who installed
and heavily customized it himself. JForum was a popular open-source Java forum engine
(jforum.net), a natural fit for a Java User Group running a Java stack. The heavy
customization explains why no obvious JForum fingerprints appeared in the archived HTML —
it was deeply integrated into the java.no portal by Totto directly.

## 4. The Forum Installation (2005) - KEY FINDING

**"During 2005, a new forum was installed on java.no where over 1,300 messages were posted"**

This is from annual meeting documents. The forum was NEW in 2005 - either
replacing something simpler or as a new addition to the portal.

### 2005 Stats
- 1,300+ messages posted in the forum
- Registered users grew from **600 to over 870**
- Over 1,000 news items, articles, comments, and lectures posted

### 2006 Stats
- Forum: **470 users**, **2,500 messages** posted
- Over 1,000 news items, articles, comments and lectures
- **Over 2 million hits per month** on www.java.no
- 180 registered company members, 490 named members
- javaBin had a dedicated **"portalgruppen" (portal group)** that held 5 meetings

NOTE: 470 forum users vs 870+ total registered site users - the forum was a
subset of the overall portal.

### 2007 Stats
- Registered users grew from 870 to over **1,100**
- 3,200+ participants from 180+ companies

## 4. The Forum Platform - UNRESOLVED

The specific forum software has NOT been definitively identified. GitHub code
search for "jive" in javaBin repos returned zero results. No references to
JForum, mvnForum, phpBB, or any named forum product were found in source code.

Most likely candidates (all Java-based, matching the era):
1. **JForum** - very popular open-source Java forum in 2005
2. **mvnForum** - another popular Java forum
3. **Jive Forums** - open-source version (last free as v1.2.4)
4. **Custom-built** - possible given javaBin's culture of building their own tools

The Wayback Machine would likely resolve this - look for URL patterns like
/jforum/, /forum/thread.jspa (Jive), or distinctive HTML/CSS signatures.

## 5. SMIA - The Forge

**"Smia" is Norwegian for "the forge" or "the smithy"** (the blacksmith's
workshop). It is NOT an acronym.

This was the name of javaBin's Confluence wiki space for technical
infrastructure projects. The metaphor: Smia was javaBin's "forge" where they
hammered out their technical infrastructure.

Referenced locations:
- wiki.java.no/display/smia/Cibus (Cibus docs)
- wiki.java.no/display/smia/Incogito (Incogito docs)
- smia.java.no (Maven repository + EMS homepage)

## 6. Pre-GitHub Version Control

**Almost certainly Subversion (SVN) was used before GitHub.** Evidence:

- javaBin GitHub org created ~2009 (earliest repos: ems-abandoned June 2009)
- The cibus repo has only **13 commits** on GitHub despite being a significant
  project - development clearly happened in another VCS
- submitit repo has 448 commits and 13 tagged releases - mature project ported
- ldap-admin2 name implies there was a ldap-admin v1 predating GitHub
- Low commit counts + mature codebases strongly imply Subversion (standard
  for Java projects in 2005-2009)

The original SVN repository location is unknown - likely on a decommissioned
server.

## 7. Portalgruppen (Portal Group)

javaBin had a dedicated working group for the website infrastructure:
- The **portalgruppen** held regular meetings (5 in 2006)
- In 2008-2009 they held **weekly meetings** working on "a new design for
  java.no and a new frontend for the existing java.no portal" - this was
  the Cibus development
- This group was separate from the meeting group (5 meetings in 2006)
  and the administration group (55 meetings in 2006!)

## 8. Complete Technology Timeline

| Period     | Platform                          | Evidence                      |
|------------|-----------------------------------|-------------------------------|
| 1998-2002  | Custom Java webapp (Servlet/JSP?) | Inferred - Java UG dogfooding |
| 2003       | Custom portal + RSS + WAP added   | Annual meeting docs           |
| 2005       | Custom portal + NEW forum         | "new forum installed" in docs |
| ~2008-2010 | Cibus (Java/Maven/Jetty/PgSQL)    | GitHub repo, wiki.java.no     |
| ~2010-2013 | Play Framework 1.2.4              | GitHub javabin-hjemmeside      |
| 2013-2022  | Jekyll (static site)              | GitHub java.no-2017            |
| 2022+      | Next.js/TypeScript on Vercel      | GitHub java.no                 |

## 9. Oldest javaBin GitHub Repos (by creation date)

1. ems-abandoned - June 16, 2009 (Event Management Suite, Java, 71 commits)
2. incogito - June 21, 2009 (JavaZone agenda planner, Java)
3. submitit - July 28, 2009 (Talk submission, Scala, 448 commits, 13 releases)
4. scala-training-code - November 16, 2009 (53 stars!)
5. cibus - February 22, 2010 (java.no portal, only 13 commits)
6. cibus2 - April 20, 2010 (JavaZone.no CMS replacement)
7. hospes - December 15, 2010 (Member database, Scala)

## 10. Key Gap: Definitive Source

Thor Henning Hetland (Totto) was president 1999-2008 and maintained java.no.
He would be the definitive source for pre-Cibus technology choices.
Reachable via:
- @javatotto / @TottoNOR on Twitter/X
- wiki.totto.org
- Through Cantara / eXOReaction

## Sources

- docplayer.me/3709172 - javaBin Annual Meeting 2003
- slideplayer.no/slide/2147256/ - javaBin Annual Meeting 2006
- cupdf.com/document/javabin-arsmote-2007.html - javaBin Annual Meeting 2007
- docplayer.me/13999056 - javaBin meeting 2004
- docplayer.me/944752 - javaBin Annual Report 2008
- docplayer.me/2167385 - javaBin Annual Report 2008-2009
- github.com/javaBin/cibus - Cibus source code
- github.com/javaBin/cibus2 - Cibus2 source code
- dynaplan.com/en/technology/smia - "Smia" word meaning
