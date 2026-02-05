---
layout: post
title: "A History of Quality in Software Engineering"
date: 2026-02-03
excerpt: "From the 1968 software crisis to BDD: tracing the evolution of quality practices through structured programming, inspections, TDD, and specification by example."
tags: [quality, tdd, bdd, xp, testing, agile]
---

Software quality practices have evolved over six decades. What began as a response
to the "software crisis" of the 1960s has grown into collaborative specification
techniques that bridge the gap between business and technical teams.


## Contents

1. [Evolution of Quality Approaches](#evolution-of-quality-approaches)
2. [The Software Crisis (1968)](#the-software-crisis-and-birth-of-software-engineering-1968)
2. [Structured Programming (1968)](#structured-programming-1968)
3. [Fagan Inspections (1976)](#fagan-inspections-1976)
4. [Cleanroom Software Engineering (1980s)](#cleanroom-software-engineering-1980s)
5. [Personal Software Process (1990s)](#personal-software-process-1990s)
6. [UML and Design Communication (1997)](#uml-and-design-communication-1997)
7. [Extreme Programming (1996-1999)](#extreme-programming-1996-1999)
8. [Test-Driven Development](#test-driven-development)
9. [Behavior-Driven Development (2006)](#the-birth-of-bdd-2006)
10. [The C4 Model (2011)](#the-c4-model-2011)
11. [Given-When-Then Format](#given-when-then-format)
12. [User Stories](#user-stories-and-acceptance-criteria)
13. [Specification by Example (2010s)](#specification-by-example-2010s)
14. [Example Mapping](#example-mapping)
15. [TDD vs BDD](#tdd-vs-bdd-choosing-an-approach)
16. [Common Pitfalls](#common-pitfalls)
17. [Key Figures](#key-figures)
18. [Further Reading](#further-reading)


## Evolution of Quality Approaches

**1968-1990s: Quality through PROCESS**

The early focus was on disciplined processes to catch defects: [Fagan Inspections](#fagan-inspections-1976) (formal peer review), [Cleanroom](#cleanroom-software-engineering-1980s) (defect prevention), and [PSP](#personal-software-process-1990s) (individual measurement).

**1994-1997: Quality through DESIGN COMMUNICATION**

Teams needed shared visual languages. [UML](#uml-and-design-communication-1997) unified competing notations into a standard for modeling software systems.

**1996-2001: Quality through PRACTICE**

[Extreme Programming](#extreme-programming-1996-1999) shifted focus to lightweight practices: [TDD](#test-driven-development), pair programming, and continuous integration.

**2001: The Agile Manifesto**

Seventeen practitioners valued "working software over comprehensive documentation," creating tension with UML-heavy approaches. Source: [Agile Manifesto](https://agilemanifesto.org/)

**2006-2011: Quality through LIGHTWEIGHT COMMUNICATION**

Bridging business and technical teams: [BDD](#the-birth-of-bdd-2006) (natural language specs), [C4 Model](#the-c4-model-2011) (just enough diagrams), and [Specification by Example](#specification-by-example-2010s) (collaborative examples).

    PROCESS --------> DESIGN --------> PRACTICE --------> LIGHTWEIGHT
    1968-1990s        1994-1997        1996-2001          2006-2011
        |                 |                |                  |
        v                 v                v                  v
    Inspections         UML            XP & TDD           BDD & C4
    Cleanroom        Sequence         Pair prog.            SbE
    PSP              diagrams            CI             Example Map

---


## The Software Crisis and Birth of Software Engineering (1968)

The term "software crisis" was coined at the first NATO Software Engineering
Conference in Garmisch, Germany in 1968. The conference, attended by over fifty
experts from eleven countries including Edsger Dijkstra, Tony Hoare, and Niklaus
Wirth, confronted a growing problem: software projects were consistently over
budget, overdue, and unreliable.

As Dijkstra later observed in his 1972 Turing Award lecture:

> "The major cause of the software crisis is that the machines have become
> several orders of magnitude more powerful... as long as there were no
> machines, programming was no problem at all; when we had a few weak
> computers, programming became a mild problem, and now we have gigantic
> computers, programming has become an equally gigantic problem."

The conference deliberately adopted the provocative term "software engineering"
to suggest that software development needed the rigor of traditional engineering
disciplines. This event marked the beginning of systematic approaches to
software quality.

---


## Structured Programming (1968)

That same year, Dijkstra published his famous letter "Go To Statement Considered
Harmful" in Communications of the ACM, marking the beginning of structured
programming.

**Definition:** A programming paradigm using block-based control flow instead of
arbitrary jumps via goto statements.


### The Three Control Structures

Dijkstra showed that any program can be written using just three constructs:

**Sequence** - Statements execute one after another in order:

    read_input()
    process_data()
    write_output()

**Selection** - Choose different paths based on a condition:

    if user_is_authenticated:
        show_dashboard()
    else:
        show_login_form()

**Iteration** - Repeat statements while a condition holds:

    while items_remaining:
        process_next_item()

**Core principle:** These three control structures are sufficient to express any
computable function (the structured program theorem).

**Key insight:** Dijkstra observed that the quality of a programmer's code was
inversely proportional to the number of gotos used. Code without gotos can more
easily be proven correct.

By the end of the 20th century, nearly all programming languages had adopted
structured programming constructs. Languages that originally lacked them
(FORTRAN, COBOL, BASIC) added support.

---


## Fagan Inspections (1976)

Michael Fagan at IBM developed formal software inspections as a systematic
method for finding defects in documents, code, and specifications.

**Definition:** A formal peer review process with predefined roles, entry/exit
criteria, and structured meetings focused solely on defect detection.


### Inspection Roles

- **Moderator:** Leads the inspection and ensures the process is followed
- **Reader:** Presents the material being inspected to the team
- **Author:** Created the work product and answers questions about it
- **Scribe:** Records all defects found during the meeting


### The Inspection Process

    +----------+    +----------+    +----------+    +----------+    +----------+    +----------+
    | Planning |--->| Overview |--->|  Prep    |--->|Inspection|--->| Rework   |--->| Follow-up|
    +----------+    +----------+    +----------+    +----------+    +----------+    +----------+
         |              |               |               |               |               |
         v              v               v               v               v               v
      Select         Author          Individual      Team finds      Author         Verify
      material,      presents        review by       defects         fixes          fixes
      assign roles   context         inspectors      (NOT solutions) defects

1. **Planning:** Select material to inspect and assign roles
2. **Overview:** Author presents context to the team
3. **Preparation:** Each inspector reviews the material individually
4. **Inspection meeting:** Team identifies defects (not solutions)
5. **Rework:** Author fixes the defects found
6. **Follow-up:** Verify that fixes are correct

**Results:** IBM reported that inspections located 82% of all errors. The
company doubled lines of code shipped while reducing defects per thousand lines
by two-thirds. Studies showed 80-90% of defects found with up to 25% resource
savings.

**Key principle:** The inspection meeting finds defects only--solutions come
later during rework.

---


## Cleanroom Software Engineering (1980s)

Harlan Mills at IBM developed Cleanroom as a theory-based process for producing
software with certifiable reliability levels.

**Definition:** A software development process emphasizing defect prevention
over defect removal, using formal methods and statistical quality control.


### Cleanroom Process

    +---------------+         +---------------+         +---------------+
    | SPECIFICATION |  --->   | DEVELOPMENT   |  --->   | CERTIFICATION |
    +---------------+         +---------------+         +---------------+

                    DEFECT PREVENTION > DEFECT REMOVAL

                         Traditional              Cleanroom
                         ----------               ---------
                         Code -> Debug -> Test    Verify -> Certify
                         Find & fix defects       Prevent defects

**Three phases:**

1. **Specification:** Requirements analysis, function specification, usage
   modeling
2. **Development:** Design with correctness verification--developers prove
   their code is correct through formal reasoning, not debugging
3. **Certification:** Independent statistical testing based on expected usage
   patterns

**Key principle:** Developers verify correctness through formal reasoning, not
debugging. A separate certification team performs all testing.

**Results:** IBM's COBOL/SF tool (85,000 lines of code) showed a ten-fold
reduction in defects during testing and five-fold improvement in developer
productivity. Only seven errors in three years of production use.

The term "Cleanroom" borrowed from semiconductor manufacturing reflects the
focus on preventing contamination (defects) rather than filtering it out later.

---


## Personal Software Process (1990s)

Watts Humphrey at the Software Engineering Institute created PSP to apply
process improvement principles to individual developers.

**Definition:** A structured self-improvement framework where engineers measure
and analyze their own performance to reduce defects and improve predictability.


### What Developers Track

- **Time:** Hours spent on each activity (design, code, test, etc.)
- **Defects:** When injected, when found, and what type
- **Size:** Lines of code predicted versus actual

> "You cannot improve what you do not measure"


### Process Levels (Progressive Adoption)

    PSP0   -->   PSP1   -->   PSP2   -->   PSP2.1
      |           |           |             |
      v           v           v             v
    Baseline    Size &      Code &       Design
    measure-    time        design       templates,
    ment        estimation  reviews      verification

- **PSP0:** Establish baseline measurements (time, defects, size)
- **PSP1:** Add size and time estimation based on historical data
- **PSP2:** Add code reviews and design reviews
- **PSP2.1:** Add design templates and formal verification

**Key principle:** By tracking personal data, engineers identify their own
defect patterns and improve systematically.

Humphrey, known as "the father of software quality," also created the Capability
Maturity Model (CMM) for organizational process improvement.

---


## UML and Design Communication (1997)

While process-focused approaches evolved, another stream addressed quality
through visual design communication. The Unified Modeling Language emerged
from the "method wars" of the early 1990s, when competing object-oriented
notations made it difficult for teams to share designs.

**Definition:** A standardized visual modeling language for specifying,
constructing, and documenting software system artifacts.


### The Three Amigos

In 1994-1996, three leading methodologists unified their competing approaches:

- **Grady Booch** brought the Booch Method, strong in design and construction
- **James Rumbaugh** brought OMT (Object Modeling Technique), strong in analysis
  and data systems
- **Ivar Jacobson** brought OOSE, strong in use cases and requirements capture

They joined at Rational Software and released UML 1.1 in 1997, which was adopted
by the Object Management Group (OMG) on November 14, 1997.


### UML Diagram Types

UML defines 14 diagram types in two categories:

**Structural diagrams** (static system view):
- Class, Object, Component, Deployment, Package, Composite Structure, Profile

**Behavioral diagrams** (dynamic system view):
- Use Case, Activity, State Machine, Sequence, Communication, Interaction
  Overview, Timing


### Sequence Diagrams

Of all UML diagrams, sequence diagrams proved most valuable and survived the
agile backlash against heavy documentation. They show how objects interact
over time:

    +--------+          +--------+          +--------+
    | Client |          | Server |          |Database|
    +---+----+          +---+----+          +---+----+
        |                   |                   |
        | 1. request()      |                   |
        |------------------>|                   |
        |                   | 2. query()        |
        |                   |------------------>|
        |                   |                   |
        |                   | 3. results        |
        |                   |<------------------|
        |                   |                   |
        | 4. response       |                   |
        |<------------------|                   |
        |                   |                   |

As Martin Fowler noted: "The primary value of drawing diagrams is communication.
Because the purpose is communication, it's essential to strip away some
information so as to clarify other information."


### UML and Agile: The Tension

UML emerged from the "big design up front" tradition--create detailed models
before coding. The Agile Manifesto (2001) explicitly valued "working software
over comprehensive documentation."

Many agile teams abandoned UML entirely. Others adopted "agile modeling"--using
diagrams for communication without treating them as formal deliverables.

---


## Extreme Programming (1996-1999)

Kent Beck developed Extreme Programming while leading the Chrysler Comprehensive
Compensation System (C3) payroll project, starting in March 1996. He refined the
methodology with Ward Cunningham and Ron Jeffries, publishing *Extreme
Programming Explained* in October 1999.

**Definition:** A software development methodology that improves quality and
responsiveness to changing requirements through short development cycles,
continuous feedback, and close customer collaboration.


### XP Values

- **Communication:** Talk constantly with each other and with the customer
- **Simplicity:** Build only what is needed now, no speculative features
- **Feedback:** Test always, release often, review code continuously
- **Courage:** Refactor aggressively, admit mistakes, discard failing approaches
- **Respect:** Value every team member's contribution (added in 2nd edition)


### The Original 12 Practices

**Planning practices:**

- <u>Planning Game</u>: Business and development collaborate each iteration to
  select and prioritize work based on value and cost estimates.
- <u>Small Releases</u>: Release to production frequently (weeks, not months) so
  each release delivers concrete business value and enables fast feedback.
- <u>Metaphor</u>: Use a shared story or analogy that everyone understands to
  guide development and name system components consistently.
- <u>Customer Tests</u>: Customers write acceptance tests that define when a
  story is complete, providing clear and testable requirements.

**Development practices:**

- <u>Simple Design</u>: Build the simplest thing that could possibly work, then
  refactor as understanding grows--no speculative generality.
- <u>Pair Programming</u>: Two programmers work together at one workstation,
  continuously reviewing each other's work and sharing knowledge.
- <u>Test-Driven Development</u>: Write a failing test before writing the code
  that makes it pass, ensuring comprehensive test coverage.
- <u>Refactoring</u>: Continuously improve code structure without changing
  behavior, keeping the design clean as requirements evolve.
- <u>Continuous Integration</u>: Integrate code into the shared repository
  multiple times per day with automated builds and tests.

**Team practices:**

- <u>On-site Customer</u>: A real customer sits with the team full-time to
  answer questions and provide immediate feedback on decisions.
- <u>Collective Ownership</u>: Anyone can modify any code, requiring coding
  standards and comprehensive tests to work safely.
- <u>Coding Standards</u>: The team agrees on coding conventions so all code
  looks familiar and anyone can work on any part.
- <u>40-Hour Week</u>: Sustainable pace prevents burnout and maintains quality,
  since tired programmers make more mistakes.


### Pair Programming

    +--------------------------------------------------+
    |                   WORKSTATION                    |
    |  +--------------------------------------------+  |
    |  |                                            |  |
    |  |              shared screen                 |  |
    |  |                                            |  |
    |  +--------------------------------------------+  |
    +--------------------------------------------------+
              |                         |
              v                         v
        +-----------+             +-----------+
        |  DRIVER   |             | NAVIGATOR |
        +-----------+             +-----------+
        | Writes    |             | Reviews   |
        | code,     |  <------>   | continuously,
        | thinks    |   rotate    | thinks    |
        | tactical  |   roles     | strategic |
        +-----------+             +-----------+

Two programmers work together at one workstation. The <u>driver</u> writes code
and thinks tactically about the current line. The <u>navigator</u> reviews
continuously and thinks strategically about the overall approach. Pairs rotate
roles frequently, and partners switch often so knowledge spreads across the
team.

Studies showed ~15% more time investment but higher quality and faster knowledge
transfer.


### Key Practices Explained

<u>On-site Customer</u>: A real customer sits with the development team
full-time to answer questions, clarify requirements, and provide immediate
feedback. This was radical--previous methodologies treated requirements as
documents thrown over a wall.

<u>Planning Game</u>: Business and development collaborate to maximize value.
Business writes User Stories on index cards describing desired features.
Development estimates effort. Business prioritizes based on value and cost.
Planning happens each iteration.

<u>Collective Code Ownership</u>: No individual owns any code. Anyone can modify
any part of the system. This requires coding standards and comprehensive tests
to work safely.

<u>Continuous Integration</u>: Developers integrate code into a shared
repository multiple times per day, with automated builds and tests. This catches
integration problems immediately rather than in a painful "integration phase."

<u>Small Releases</u>: Release to production frequently--weeks, not months. Each
release delivers concrete business value. Short cycles mean faster feedback and
easier course correction.

**Key insight:** XP takes practices that work and turns them to "extreme"
levels--if testing is good, test constantly; if code review helps, review
continuously via pairing; if integration is painful, integrate continuously.

The C3 project was cancelled in February 2000 after Daimler-Benz acquired
Chrysler, but XP had already spread. Beck was among the seventeen signatories
of the Agile Manifesto in 2001.

---


## Test-Driven Development

TDD emerged as one of XP's core technical practices but became influential in
its own right.

**Definition:** A development technique where you write a failing test before
writing the code that makes it pass, followed by refactoring.


### The Red-Green-Refactor Cycle

              +-------+
              | WRITE |
              | TEST  |
              +---+---+
                  |
                  v
            +-----------+
            |   RED     |  <-- Test fails
            |  (fail)   |
            +-----+-----+
                  |
                  | write minimal code
                  v
            +-----------+
            |  GREEN    |  <-- Test passes
            |  (pass)   |
            +-----+-----+
                  |
                  | improve structure
                  v
            +-----------+
            | REFACTOR  |  <-- Keep tests green
            |           |
            +-----+-----+
                  |
                  +---------> repeat

1. <u>Red</u>: Write a test for the next bit of functionality--it should fail
2. <u>Green</u>: Write the minimal code needed to make the test pass
3. <u>Refactor</u>: Improve the code structure while keeping all tests green

As Martin Fowler notes, the most common mistake is neglecting the third step--
skipping refactoring leads to messy code accumulation.

**Two primary benefits:**

- Self-testing code: implementation only occurs in response to test requirements
- Better design: thinking about interfaces before implementation separates
  concerns naturally

**Theoretical foundation:** J.B. Rainsberger grounds TDD in queuing theory--when
process B requires reworking process A, efficiency improves by performing part
of B before A begins. This eliminates wasteful rework cycles.

---


## The Birth of BDD (2006)

Dan North introduced Behavior-Driven Development as an evolution of TDD that
addresses a common problem: developers struggling with where to start testing,
what to test, and how much to test at once.


### TDD vs BDD Focus

    TDD Question:                    BDD Question:
    "How do we test this code?"      "What behavior should this system exhibit?"

            CODE                              BEHAVIOR
              |                                   |
              v                                   v
        Implementation                      User outcomes
        details                             and value

BDD shifts focus from implementation details to behavior and user outcomes. The
key insight was applying the same queuing theory principle at the analysis
level--implementing features reveals insights about other features.

This practice involves business and technical people writing examples together
to establish shared understanding.

---


## The C4 Model (2011)

Simon Brown developed the C4 model between 2006-2011 as a response to teams
abandoning architecture diagrams entirely. While agile practitioners rejected
heavyweight UML, they still needed ways to communicate system structure.

**Definition:** A hierarchical approach to visualizing software architecture at
four levels of abstraction: Context, Containers, Components, and Code.


### The Four Levels

    Level 1: CONTEXT                    Level 2: CONTAINERS
    "What is the system?"               "What's inside the system?"
    +-------------------------+         +-------------------------+
    |                         |         |  +-----+  +-----+       |
    |   [Users]--->[System]   |         |  | Web |  | API |       |
    |              /    \     |         |  | App |  |     |       |
    |             v      v    |         |  +--+--+  +--+--+       |
    |      [External] [Mail]  |         |     |        |         |
    |       System   Service  |         |     v        v         |
    |                         |         |  +-------------+       |
    +-------------------------+         |  |  Database   |       |
    For: Everyone                       |  +-------------+       |
    (business + technical)              +-------------------------+
                                        For: Technical people

    Level 3: COMPONENTS                 Level 4: CODE
    "What's inside a container?"        "How is component implemented?"
    +-------------------------+         +-------------------------+
    |  API Container          |         |                         |
    |  +--------+ +--------+  |         |   Class diagrams        |
    |  |  Auth  | | Order  |  |         |   (usually auto-        |
    |  |Handler | |Service |  |         |    generated from       |
    |  +--------+ +--------+  |         |    source code)         |
    |       \      /          |         |                         |
    |        v    v           |         |   Rarely used--too      |
    |    +----------+         |         |   detailed for most     |
    |    |Repository|         |         |   purposes              |
    |    +----------+         |         |                         |
    +-------------------------+         +-------------------------+
    For: Developers/architects          For: Detailed design

- <u>Level 1 - Context</u>: Shows the system in its environment with users and
  external systems. Suitable for everyone including non-technical stakeholders.
- <u>Level 2 - Containers</u>: Zooms into the system to show applications,
  databases, and services. For technical audiences.
- <u>Level 3 - Components</u>: Zooms into a container to show internal
  components. For developers and architects.
- <u>Level 4 - Code</u>: Class-level diagrams, usually auto-generated. Rarely
  used as it's too detailed for most purposes.

**Key principle:** Good diagrams are about communication, not compliance with a
notation standard. Use whatever helps the team understand the system.

Brown has taught the C4 model to over 10,000 people in ~40 countries, reflecting
demand for lightweight architecture visualization that agile teams will use.

---


## Given-When-Then Format

The Given-When-Then syntax became the dominant format for expressing
specifications. According to Gojko Adzic's 2020 survey, this format accounts
for 71% of usage versus less than 10% for table-based formats.


### Structure

- **Given** - The context or setup (preconditions)
- **When** - The action or event that triggers the behavior
- **Then** - The expected outcome

**Example:**

    Given a registered user with valid credentials
    When they submit the login form
    Then they should see their dashboard

The format won adoption due to a good balance between expressiveness and
developer productivity. Its simplicity enabled broader tooling support and
better IDE integration.

---


## User Stories and Acceptance Criteria

Dan North's work on user stories established a template that connects behavior
to business value:

    As a [role]
    I want [feature]
    So that [benefit]

**Example:**

    As a homeowner
    I want to schedule recurring cleaning appointments
    So that I don't have to remember to book each time

This format keeps the focus on who needs what and why, rather than jumping
straight to implementation details. Stories serve as placeholders for
conversations, not detailed specifications.

---


## Specification by Example (2010s)

Gojko Adzic's Specification by Example (SbE) formalized the collaborative
approach where teams use concrete examples to define acceptance criteria, guide
development, and create executable tests.

**Key findings from his 2020 survey after 10 years of SbE adoption:**

- Teams using examples as acceptance criteria: 22% rated software as "Great"
  (vs 8% without)
- 47% of teams now define acceptance criteria collaboratively with business
- One-third don't automate examples--yet automation correlates with 2x quality
  ratings

---


## Example Mapping

Example Mapping emerged as a structured conversation technique for exploring
user stories before development begins. Teams use colored cards to capture
different elements of a story.


### Card Types

- **Yellow card:** The user story being discussed
- **Blue cards:** Rules or acceptance criteria that govern the story
- **Green cards:** Concrete examples that illustrate each rule
- **Red cards:** Questions that need answers before development can proceed


### Example: Cleaning Scheduling Service

**Story (Yellow):**

    As a homeowner
    I want to reschedule a cleaning appointment
    So that I can adjust to changes in my calendar

**Rule 1 (Blue):** Rescheduling must be done at least 24 hours in advance

- Example (Green): Appointment on Friday 2pm, customer reschedules Wednesday
  at 3pm -> Allowed
- Example (Green): Appointment on Friday 2pm, customer reschedules Thursday
  at 4pm -> Denied with message "Less than 24 hours notice"

**Rule 2 (Blue):** Customers can only reschedule to available time slots

- Example (Green): Customer selects Saturday 10am which shows as available ->
  Appointment moved to Saturday 10am
- Example (Green): Customer selects Saturday 10am which is fully booked ->
  Slot not shown in available options

**Rule 3 (Blue):** Rescheduling is free for the first change, then costs $15

- Example (Green): First reschedule of appointment -> No fee charged
- Example (Green): Second reschedule of same appointment -> $15 fee shown
  before confirmation

**Questions (Red):**

- What happens if the cleaner cancels? Does that reset the customer's free
  reschedule?
- Can customers reschedule to a different cleaner?
- Should we send a confirmation email after rescheduling?

This approach surfaces ambiguity and missing requirements early, when changes
are cheapest. If a story has too many red cards, it needs more discovery. If
it has too many blue cards, it might need to be split into smaller stories.

---


## TDD vs BDD: Choosing an Approach

    Aspect          TDD                       BDD
    ------          ---                       ---
    Focus           Implementation details    User behavior
    Language        Programming language      Natural language
    Audience        Developers                Stakeholders + developers
    Scope           Unit level                System interactions
    Primary use     Code quality/design       Requirements communication

Both methodologies write tests before implementing code and create automated
test suites.

**Use TDD when:** prioritizing code quality and design, working in continuous
integration environments, or needing rapid developer feedback.

**Use BDD when:** requiring non-technical stakeholder involvement, building
user-centric applications, or dealing with complex business logic needing clear
communication.

---


## Common Pitfalls

### TDD Pitfalls

- Over-testing minor functions
- Skipping refactoring (the third step)
- Writing code before tests

### BDD Pitfalls

- Creating overly vague or excessively detailed scenarios
- Excluding stakeholders from specification conversations
- Failing to automate the examples

---


## Key Figures

See [Further Reading](#further-reading) for links to their work.

### Pre-XP Era

- **Edsger Dijkstra:** Structured programming, "Go To Statement Considered
  Harmful" (1968)
- **Michael Fagan:** Formal software inspections at IBM (1976)
- **Harlan Mills:** Cleanroom software engineering at IBM (1980s)
- **Watts Humphrey:** Personal Software Process, CMM, "father of software
  quality" (1990s)

### Design Communication (UML Era)

- **Grady Booch:** Booch Method, co-creator of UML, one of the "Three Amigos"
- **James Rumbaugh:** Object Modeling Technique (OMT), co-creator of UML
- **Ivar Jacobson:** Use cases, OOSE method, co-creator of UML

### XP and Agile Era

- **Kent Beck:** Created XP and TDD at Chrysler C3 project (1996). Author of
  *Extreme Programming Explained* and *Test-Driven Development*. Agile
  Manifesto signatory
- **Ward Cunningham:** Co-developed XP practices with Beck. Created the wiki,
  CRC cards, and FIT testing framework
- **Ron Jeffries:** XP coach on C3 project, helped codify and spread XP
  practices. Agile Manifesto signatory
- **Martin Fowler:** Wrote extensively on refactoring, TDD, patterns, and UML.
  Agile Manifesto signatory
- **Dan North:** Introduced BDD in 2006 as evolution of TDD
- **Gojko Adzic:** Authored *Specification by Example* and conducted industry
  surveys on adoption
- **J.B. Rainsberger:** Connected TDD to queuing theory and its productivity
  benefits
- **Simon Brown:** Created C4 model (2006-2011), author of *Software
  Architecture for Developers*, founder of Structurizr

---


## Further Reading

### Historical Foundations

- [NATO 1968 Conference Report](http://homepages.cs.ncl.ac.uk/brian.randell/NATO/nato1968.PDF)
- [Go To Statement Considered Harmful](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf) - Dijkstra
- [Fagan Inspection](https://en.wikipedia.org/wiki/Fagan_inspection)
- [Cleanroom Software Engineering](https://en.wikipedia.org/wiki/Cleanroom_software_engineering)
- [Personal Software Process](https://resources.sei.cmu.edu/library/asset-view.cfm?assetid=5283) - SEI

### Design Communication

- [Unified Modeling Language](https://en.wikipedia.org/wiki/Unified_Modeling_Language) - Wikipedia
- [UML Diagrams](https://www.uml-diagrams.org/) - Reference guide
- [C4 Model](https://c4model.com/) - Simon Brown's official site
- [Software Architecture for Developers](https://leanpub.com/visualising-software-architecture) - Simon Brown
- [Sequence Diagrams](https://en.wikipedia.org/wiki/Sequence_diagram) - Wikipedia

### Extreme Programming

- [What is Extreme Programming?](https://ronjeffries.com/xprog/what-is-extreme-programming/) - Ron Jeffries
- [Extreme Programming](https://en.wikipedia.org/wiki/Extreme_programming) - Wikipedia
- [About Extreme Programming](https://extremeprogrammingalliance.com/about-extreme-programming-xp/) - XP Alliance

### TDD and BDD

- [Test-Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html) - Martin Fowler
- [Introducing BDD](https://dannorth.net/introducing-bdd) - Dan North
- [What's in a Story?](https://dannorth.net/whats-in-a-story/) - Dan North
- [BDD is like TDD if...](https://dannorth.net/bdd-is-like-tdd-if/) - Dan North
- [How Test-Driven Development Works](https://blog.jbrains.ca/permalink/how-test-driven-development-works-and-more) - J.B. Rainsberger
- [SbE: 10 Years Later](https://gojko.net/2020/03/17/sbe-10-years.html) - Gojko Adzic
- [TDD vs BDD](https://refine.dev/blog/tdd-vs-bdd/) - Refine
- [Example Mapping](https://examplemapping.com/)
