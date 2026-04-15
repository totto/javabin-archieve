# JavaZone Conference Programs - Early Years Detail

## Verified Speakers and Talks by Year

### JavaZone 2002 (Inaugural)
- 350 participants, Chateau Neuf basement
- Sun Microsystems initiative, javaBin ensured technical quality
- Specific speakers: NOT YET RECOVERED (need Wayback for www4.java.no/javazone/2002)

### JavaZone 2003
- ~400 participants, Chateau Neuf
- Specific speakers: NOT YET RECOVERED

### JavaZone 2004
- javaBin took over fully. SAS Hotel (Radisson SAS), Holbergs plass
- 800-900 participants, 23 partners
- Rod Johnson (Spring) may have spoken (referenced speaking "2004/2005")
- Video existed for 2004 (noted in jz09 backstory: "2004 with video")

### JavaZone 2005
- ~1,000 participants, Radisson SAS
- **Knut Magne Risvik** (Google Inc.) - "Java @ Google" (Sept 14, 2005)
  - Covered GFS, MapReduce, Java at Google
  - Mentioned Joshua Bloch and Neal Gafter as Google Java talent
- **Ted Neward** - "Concrete Services" + selections from "Effective Enterprise Java"
- Mule ESB presentation (slideshare: "javazone-2005-mule-real-world-old")

### JavaZone 2006 (1,400 attendees, sold out 1 month early)
Confirmed as 2nd biggest Java conference in Europe that year.

Confirmed speakers (from thekua.com review):
- **Joshua Bloch** (Google) - Effective Java author
- **Rod Johnson** - Spring Framework creator (CONFIRMED at JavaZone)
- **Gavin King** - Hibernate creator
- **Bruce Tate** - author, Beyond Java
- **James Strachan** - Groovy/ActiveMQ creator
- **Floyd Marinescu** - TheServerSide founder
- **Ken Schwaber** - Scrum co-creator
- **Mary Poppendieck** and **Tom Poppendieck** - Lean Software Development
- **Johannes Brodwall** - Norwegian developer/speaker
- Reviewer from thekua.com presented: "Test Driving Swing Applications"

Topics: Core Java (Swing, Java 5, memory tuning), Enterprise Java (EJB3, SOA,
web services), Web (JSF, GWT), Testing (Watir, Selenium), Methodology (Scrum,
Lean), Mobile/Embedded Java.

### JavaZone 2007 (~2,000 attendees, 6 tracks, 1-hour talks)
- Talk: "Java Persistence on the Client" (referenced at wcgw.dev)
- Tribute year for Totto and Stein stepping down
- No traditional keynotes; 1-hour talk format established

### JavaZone 2008 (2,300 attendees, 47 partners, Oslo Spektrum)
6 tracks, ~100 sessions. First year of comprehensive video recording.

Confirmed speakers and talks:
- **Gilad Bracha** - NewSpeak (called "the best presentation at JavaZone" by Ola Bini)
- **Robert C. Martin (Uncle Bob)** - "Functions" / Clean Code
- **Mary Poppendieck** - "The Double Paradox of Lean Software Development"
- **Michael Feathers** - "Cultivating Deep Software Design Skill"
- **Rickard Oberg** - "Qi4j - a new approach to old problems" (Composite Oriented Programming)
- **Ola Bini** - talk about Ioke language
- **Heidi Arnesen Austlid** - Open Source in the public sector

### JavaZone 2009 (Sept 9-10, Oslo Spektrum, 2,000+ expected)
Program head: Andreas Roe. 100+ presentations.

Confirmed speakers:
- **Neal Ford** - "Productive Programmer"
- **Matthew McCullough** - "Open Source Debugging"
- **Niclas Hedhman** - "Qi4j Persistence"

Program used Incogito system (javazone.no/incogito09).

Tracks: Core Java, Tools & Techniques, Java Frameworks, Frontend, Usability,
Embedded/Mobile/Gaming, Enterprise Architecture, Web as Platform, Architecture
& Design, Agile, Alternative Languages, Experience Reports, Green IT.

Program PDFs existed: jz_program_09.pdf, miniagenda, session/lightning talk
PDFs for day 1 and day 2 (in jz-web-archive repo as binary PDFs).

### JavaZone 2014 (Sept 9-11)
90 presentations + 60 lightning talks + 12 workshops.
- **Kent Beck** - "Software Design, Why, When and How" (keynote)
- **Neal Ford** - "Continuous Delivery for Architects"
- **Tom Gilb** and **Michael Huttermann** also spoke

---

## Speaker Name Dataset (809 unique names)

GitHub repo heidisu/javazone2016-ml contains NER-extracted speaker entity data
with 809 unique person names from JavaZone bios across all years.

Notable names in the dataset:
- Joshua Bloch, Kent Beck, Neal Gafter, Uncle Bob (Robert C. Martin)
- Ted Neward, Kevlin Henney, Rickard Oberg
- Trygve Reenskaug (MVC pattern inventor - Norwegian!)
- Ward Cunningham, Tom Gilb, Bjarne Stroustrup
- Stephen Colebourne, Aslak Hellesoy (Cucumber creator - Norwegian!)
- Sven Efftinge, Viktor Klang
- Plus hundreds of Norwegian speakers

Source: https://github.com/heidisu/javazone2016-ml

---

## JavaZone Technical Infrastructure

### Program Systems Over Time
1. **2002-2008**: Manual/website-based program
2. **2008-2011**: Incogito agenda planner (javaBin/incogito on GitHub)
   - URLs: javazone.no/incogito09, incogito10, etc.
   - Tech: Jetty/Derby/Voldemort
3. **2009-2016**: EMS (Event Management Suite)
   - First version: javaBin/ems-abandoned (Restlet/Java)
   - Second version: javaBin/ems-redux (Scala/MongoDB, Collection+JSON API)
   - Public API was at javazone.no/ems/server/events
   - "Holds all talks submitted to JavaZone throughout history"
4. **2016+**: SleepingPill (javaBin/sleepingPillCore)
   - API at sleepingpill.javazone.no
5. **Current**: talks.javazone.no (CFP system)

### Video Archives
- Vimeo: vimeo.com/javazone - 1,300+ talks, all free
- Videos from 2008/2009 onward
- Pre-2008 video very limited (2004 had some video per backstory page)
- The famous JavaZone promotional short films started ~2008
- InfoQ also hosts some talks: infoq.com/javazone/presentations/

### Year-Specific Domains
Pattern: YYYY.javazone.no
- 2006-2008: may still redirect or have content
- 2009-2012: preserved in jz-web-archive GitHub repo
- 2013-2024: year-specific repos on GitHub
- 2014 speakers page confirmed at 2014.javazone.no/speakers.html

---

## Key URLs for Further Research

### Must-Check Wayback Machine URLs
- web.archive.org/web/*/www4.java.no/javazone/2002
- web.archive.org/web/*/www4.java.no/javazone/2003
- web.archive.org/web/*/www4.java.no/javazone/2004
- web.archive.org/web/*/www4.java.no/javazone/2005
- web.archive.org/web/*/javazone.no (2006+)

### GitHub Resources
- javaBin/jz-web-archive - jz09 contains program PDFs as binary files
- javaBin/ems-redux - historical talk database (Scala/MongoDB)
- heidisu/javazone2016-ml - 809 speaker names extracted via NER
- javaBin/incogito - agenda planner with session data

### External Archives
- InfoQ JavaZone section: infoq.com/javazone/presentations/
- Vimeo: vimeo.com/javazone (1,300+ videos)
- thekua.com - JavaZone 2006 review with speaker list
- blog.f12.no - JavaZone 2008 review
