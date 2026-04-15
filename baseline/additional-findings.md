# Additional Findings - java.no / javaBin Deep Research

## 1. Post-Totto Leadership (2008-2016)

### The Transition (2008)
After Thor Henning Hetland (Totto) and Stein Grimstad stepped down ~2007/2008,
the next generation took over:

**Board 2008 (elected April 17, 2008 at IFI):**
- Kjetil Paulsen - Leder (Leader/Chair)
- Trygve Laugstol - Nestleder (Vice Chair)
- Jonas Lantto - Okonomiansvarlig (Finance)
- Andreas Roe - JavaZone-gruppeleder (JavaZone Group Leader)
- Rune P. Bjornstad - Board member
- Rune Schumann - Board member

**Board 2008-2009 (from annual report):**
- Andreas Roe - Leder (Leader)
- Linus Foldemo - Nestleder (Vice)
- Are Thobias Tysnes - Okonomiansvarlig (Finance)
- Kristian Nordal - Board member

**~2012:**
- Pal Nedrelid - Constituted leader

**Board 2016/2017 (from May 28, 2016 annual meeting at Teknologihuset):**
- Rustam Mehmandarov - Styreleder (Board Chair) (1 year)
- Dervis Mansuroglu - Nestleder (Vice Chair) (1 year)
- Stian Nygaard - Okonomiansvarlig (Finance) (1 year)
- Ingar Abrahamsen (2 years)
- Eivind Hyldmo (2 years)
- Sveinung Dalatun (1 year)
- Henrik Nordvik (1 year)
- Marvin B. Lillehaug (1 year)
- Trygve Laugstol (1 year) - still active from 2008!
- Espen Herseth Halvorsen (1 year)
- Bjorn Hamre (1 year)

### Leadership Chain Summary
1. Thor Henning Hetland (Totto) - 1998-2008
2. Kjetil Paulsen - 2008
3. Andreas Roe - 2008-2009
4. (gap - Pal Nedrelid ~2012)
5. Rustam Mehmandarov - 2016-2017+
6. Dervis Mansuroglu - Vice 2016+

---

## 2. javaBin Okonomi AS (Org.nr 991 812 733)

A separate limited company (aksjeselskap) 100% owned by javaBin, created for
JavaZone event risk management. From the vedtekter: javaBin cannot sell shares;
must have minimum 2 board representatives.

**Registration:** October 15, 2007 (founded September 17, 2007)
**Address:** Universitetsgata 2, 0164 Oslo
**Postal:** Postboks 6741 St. Olavs Plass, 0130 Oslo
**Sector:** Congress, Fair, and Exhibition (Messe- og kongressarrangor)

**Current Management:**
- CEO (Daglig leder): Carl Jacob Onstad
- Board Chair (Styreleder): Oyvind Lokling
- Board Members: Carl Jacob Onstad, Jan Erik Robertsen, Rafael Mario Winterhalter

Note: Carl Onstad (the original "third pillar" from the early days) is still
running the company side. Oyvind Lokling (board member since 2003) chairs it.
Rafael Winterhalter is a well-known Java Champion (ByteBuddy creator).

**Financial Data (2008-2009 annual report):**
- Sponsor contributions: 2,888,421 NOK
- Ticket sales: 7,002,947 NOK
- javaBin contingents: 198,329 NOK
- Total costs: 7,122,700 NOK
- Net result before tax: 3,121,739 NOK

---

## 3. javaBin Vedtekter (Bylaws) - Key Points

Source: https://github.com/javaBin/vedtekter/blob/master/Vedtekter.md

**Purpose:** Strengthen technical expertise in Java technology by spreading
knowledge of relevant results, practical methodology and useful tools. Create
contact and promote knowledge exchange between those interested in Java.

**Activities:** Expert groups, project-oriented activities, seminars, courses,
member meetings with expert presentations and discussions, international
cooperation.

**Non-commercial:** No commercial interests, must not engage in activities
that serve exclusively economic purposes.

**Membership:** Personal, one vote per member. Proxies allowed (max 3).
Single employer cannot control more than 5 votes total.

**Board:** 5-15 members. Chair/Vice-Chair max 2 consecutive terms.
Treasurer elected annually. Other members serve 2-year terms.

**Annual meeting (Arsmotet):** By June 1st. Elects board, approves accounts
and budget.

**Bylaw changes:** 4/5 majority for critical sections (amendments,
dissolution, purpose); 2/3 for others.

---

## 4. JavaZone Official Backstory (from 2009 archive)

Source: github.com/javaBin/jz-web-archive jz09.java.no/about-javazone/backstory

"This marks JavaZone's eighth consecutive year. The conference began as a Sun
Microsystems initiative in 2002 with 350 attendees in the basement of Chateau
Neuf, a popular Oslo University student venue. The javaBin user group was
tasked with maintaining technical standards.

By 2004, javaBin assumed full event management with Sun Microsystems as one
of several partners. The venue relocated to the SAS Hotel on Holbergs plass
in Oslo, accommodating 800 participants and 23 partners.

Over the following three years, attendance grew progressively: 800, then 1,000,
reaching 1,400 participants. The 2008 edition peaked at 2,300 participants
with 47 partners."

### Corrected Timeline (from official source)
| Year | Attendees | Partners | Venue               | Notes                    |
|------|-----------|----------|---------------------|--------------------------|
| 2002 | 350       | -        | Chateau Neuf        | Sun Microsystems init    |
| 2003 | ~400      | -        | Chateau Neuf        | -                        |
| 2004 | 800       | 23       | SAS Hotel Holbergs  | javaBin takes over fully |
| 2005 | 800       | -        | SAS Hotel           | -                        |
| 2006 | 1,000     | -        | SAS Hotel           | -                        |
| 2007 | 1,400     | -        | Oslo Spektrum?      | -                        |
| 2008 | 2,300     | 47       | Oslo Spektrum       | -                        |
| 2009 | sold out  | -        | Oslo Spektrum       | 8th year                 |

Note: The official backstory says 800 in 2004 with growth to 800, 1000, 1400
over three years - slightly different from the Olve Maudal blog numbers
(900, 1000, 1400). The official source is probably more accurate.

---

## 5. JavaZone Historical Data Systems

### ems-redux (Event Management System)
GitHub: github.com/javaBin/ems-redux
"Baksystemet som holder pa alle foredrag som er sendt inn til JavaZone
gjennom historien" (The backend system that holds all talks submitted to
JavaZone throughout history)

### sleepingPillCore
GitHub: github.com/javaBin/sleepingPillCore
Current replacement for EMS.

### submitit-redux
GitHub: github.com/javaBin/submitit-redux
Call-for-papers submission app that sends to EMS.

### cake-redux
GitHub: github.com/javaBin/cake-redux
Program committee tool for evaluating/scheduling talks. No database -
reads/writes all data from EMS.

### javazone-web-api
GitHub: github.com/javaBin/javazone-web-api
Backend that fetches talks from EMS and presents them in JSON.

### jz-web-archive
GitHub: github.com/javaBin/jz-web-archive (archived Sep 28, 2023)
Contains wget-scraped copies of JavaZone websites from 2009-2012:
- jz09.java.no
- jz10.java.no
- jz11.java.no
- jz12.java.no

Each contains: about-javazone/, backstory/, crew/, entertainment/,
expo/, organiser/, oslo-spektrum/, what-is-javazone/, whiteboards/

### Year-specific JavaZone repos
github.com/javaBin/javazone-2020 through javazone-2022
github.com/javaBin/2024.javazone.no (built with Astro)

---

## 6. Duke's Choice Award 2019

javaBin won the Duke's Choice Award in 2019. The award winners were announced
at Oracle Code One (successor to JavaOne) in San Francisco.

Other 2019 winners included: CarePay, Jakarta EE, Dataverse, Chris Thalinger,
and Denver Java User Group.

Dervis Mansuroglu was awarded Java Champion title one month after javaBin
received the Duke's Choice Award.

---

## 7. Key GitHub Repositories (javaBin org - 110+ repos)

### Active Systems
- java.no - Current website (Next.js/TypeScript)
- sleepingPillCore - Talk management
- cake-redux - Program committee tool
- submitit-redux - Talk submission
- vedtekter - Bylaws (Markdown, version controlled!)
- docs - Organization overview

### Historical/Legacy ("LEGAZY")
- javazone.no - Old JavaZone React website (2018 era)
- jz-web-archive - Scraped JavaZone sites 2009-2012
- cibus2 - Old CMS for JavaZone.no
- ems-redux - Historical talk database
- ems-abandoned - Even older EMS (Java/Restlet)

### Infrastructure
- Platform repo with Terraform
- CLI tool for common tasks
- Registry for team/hero management

---

## 8. Additional Sources Found

### DocPlayer Documents
- javaBin Arsmotet Feb 5, 2003: docplayer.me/3709172
- javaBin Annual Report 2008: docplayer.me/944752
- javaBin Annual Report 2008-2009: docplayer.me/2167385
- javaBin Arsmotet 2016 Minutes: docplayer.me/26746713

### Confluence Wiki
- javabin.atlassian.net/wiki/spaces/javabin/
- Annual report 2019: pages/677649586
- Teknologihuset page: pages/677649558
- Resource page: pages/677648395

### Year-specific JavaZone sites (may still work)
- 2013.javazone.no through 2024.javazone.no
- talks.javazone.no (current CFP system)
- jz.java.no (legacy archive gateway)

### Video Archives
- Vimeo: vimeo.com/javazone - 1500+ historical talks
- YouTube: JavaZone channel
- Earliest videos likely from 2008 onwards
