---
layout: post
title: "From request to e-mail: one slice of work with AI"
date: 2026-10-09
last_modified_at: 2026-10-09
author: Robert Hopman
tags: [ai, process, testing, sdlc, claude-code]
description: The thirteen steps that one slice of client work goes through, from the request to the e-mail that closes it, and the five points where I decide and the AI does not.
---

I build a client application with an AI agent. Each piece of work, a slice, goes through the same thirteen steps. The AI does most of them. I decide at five points.

![Thirteen steps on one circle: request, evidence, real confirmed examples, plan, engineering review, build red then green, mutation check, test-quality scan, full checks, PR, merge and deploy, production check, e-mail. Five steps are blue: there I decide. A dashed arrow from the e-mail back to the request says: the answer is the next request.](/assets/images/from-request-to-e-mail-cycle.svg)

## The steps

```text
#   Step                 Who         What happens                                     Gate / evidence
--  ----                 ---         ------------                                     ---------------
1   Request              client,     a wish in an e-mail, a spec chapter, or an       spec and input documents in the repo
                         me          answer to an open question
2   Evidence             AI          read-only probe of each external system;         real response saved as a test
                                     response time noted                              fixture, personal data replaced
3   Real confirmed       AI,         one real production record per calculation or    the client confirms before the
    example              client      rule, picked so the wrong rule gives another     review
                                     result
4   Plan                 AI          a plan document on the branch: tasks, real       plan committed before any code
                                     confirmed examples, failure-mode table
5   Engineering review   AI, me      4 passes + failure modes; one question per       I decide each finding; the
                                     finding                                          decisions go into the plan
6   Build, per behavior  AI          test red for the right reason, then green,       many small commits per PR
                                     then commit
7   Mutation check       AI          break the code on purpose, see a test fail,      the code is restored, no diff
                                     restore
8   Test-quality scan    AI          scan the changed tests against a baseline from   separate test commits for real
                                     main; fix real smells, keep the ones that the    smells
                                     house rules ask for
9   Full checks          AI          unit tests, system tests, linter, security       counts in the summary
                                     scan
10  PR                   AI          PR body in the client's language; open choices   CI green; I can click through
                                     as "build unless you object" points              the app locally
11  Merge + deploy       AI, me      only after my go; production writes (seed,       production answers 200; numbered
                                     backfill) go to me to run myself                 gates for each production step
12  Production check     AI          read-only check on a real record                 the result in the summary
13  E-mail               AI, me      an e-mail to the client as a page with a copy    the e-mail goes out from me
                                     button: what is live, open questions, "build
                                     unless you object" points. I send it.
```

## Why it is a circle

The e-mail at the end usually holds the open questions and the real confirmed examples for the next slice. The client's answer then becomes step 1 and step 3 of that slice. So the last step starts the next round.

## Who decides

I decide at five points:

- what gets built (step 1)
- the real confirmed examples (step 3)
- each review finding (step 5)
- the go to merge and deploy (step 11)
- sending the e-mail (step 13)

The AI does the rest: the evidence, the plan, the build, the checks, the PR, the deploy and the production check.

