---
layout: post
title: "Diagnose a bug: build the feedback loop first"
excerpt: "The scientific method for a defect. Six phases, three loops, and an exit criterion for each phase."
tags: [debugging, testing, process]
sidebar: diagnose-a-bug
---

## The method

This process applies the scientific method to a defect. The six phases are the steps of that method. They carry the names a developer uses.

```
Scientific method       Phase                      You produce
-----------------       -----                      -----------
Build the apparatus     1. Build a feedback loop   one command that goes red on this bug
Observe under control   2. Reproduce and minimise  a minimal case that repeats
State the hypotheses    3. Write the hypotheses    3 to 5 ranked causes, each with a prediction
Run the experiment      4. Instrument              one probe per prediction, one variable at a time
Confirm the result      5. Fix and add a test      a test that fails before the fix, passes after
Publish and improve     6. Clean up and review     a clean repository and a recorded cause
```

This page expands phase 1 only. The loop makes phases 2 to 6 mechanical. The table above states what each phase asks for.

Two rules come with the method. Keep them in front of you for phases 3 and 4.

1. A cause you cannot falsify is not a hypothesis. State the prediction it makes, or discard the cause.
2. An experiment with two changed variables proves nothing. Change one variable per probe.

A probe reads one value from inside the code. You place it at one point. It shows you what the code does not otherwise show you.

A REPL debugger is the strongest probe. It stops the code, then it lets you read the real state and call the suspect function. A log line and a watch expression are weaker probes. Phase 6 removes every one of them.

The loop comes first. Phase 1 carries the weight for this reason. You cannot observe, experiment or confirm without the loop.

## The process

<img src="/assets/images/diagnose-a-bug-sequence.svg" alt="A sequence diagram with four lifelines: You, Loop, Code and Probe. In phase 1 you write one command that can go red. A dashed loop box holds the tighten step, until the loop is fast and deterministic. In phase 2 the loop runs the code, the code returns a wrong result, and the loop reports RED. A second dashed loop box holds one step: cut one element and run the loop again. It repeats until every element is load bearing. In phase 3 you rank 3 to 5 falsifiable causes. In phase 4 a third dashed loop box holds four steps: set one probe on the top cause, observe one value, read the actual value, and reject the cause. It repeats until one cause is confirmed. In phase 5 you add the regression test and the fix, then run the loop again and get GREEN. In phase 6 you remove every probe." style="max-width:100%;height:auto;">

The four lifelines are you, the loop, the code under test and the probe. Read the diagram from the top. The three dashed boxes are the loops.

I built the generator with the method in [Drawing Open Circular Cycle Diagrams with a Python SVG Generator](/drawing-open-circular-cycle-diagrams-in-svg/). The code is at `assets/images/diagnose-a-bug-sequence.py`.

## The three loops

The six phases run in order one time. Three phases repeat inside themselves. The phase numbers hide the repeats, so read this table before you start.

```
Loop                 Repeat this                     Leave the loop when
----                 -----------                     -------------------
Inside phase 1       tighten the loop                it is red capable, deterministic and fast
Inside phase 2       cut one element, run the loop   every element is load bearing
Inside phase 4       probe the next ranked cause     one cause is confirmed
```

The third loop holds most of the work. A rejected cause returns you to the top of that loop. Take the next cause and probe again. Expect three to five turns.

## Phase 1: Build a feedback loop

Produce the loop. The loop is one command. It goes red on this bug. It goes green when you fix the bug.

Phase 1 is the skill. The other five phases are mechanical. Spend most of your effort here. Be aggressive. Be creative. Do not give up.

1. Take the first loop from the table below that reaches the bug.
2. Build it.
3. Run it. Confirm that it goes red.
4. Tighten it against the three rules below.
5. Repeat step 4 until you meet the exit criterion.

### Choose the loop

```
Order  Loop                 What it is
-----  ----                 ----------
1      Failing test         a test at the seam that reaches the bug
2      HTTP call            curl against the development server
3      CLI call             a fixture input, diff stdout against a good snapshot
4      Headless browser     Playwright or Puppeteer, assert on the DOM, console and network
5      Replay a trace       save a real payload or event log, replay it in isolation
6      Throwaway harness    a small program that calls the bug path with mocked dependencies
7      Fuzz loop            run 1000 random inputs, count the failures
8      Bisect harness       a script that git bisect run can call
9      Differential loop    run one input on two versions or two configs, diff the output
```

Row 1 accepts any seam: unit, integration or end to end. Take the seam that reaches the bug with the least setup.

### Tighten the loop

Treat the loop as a product. Improve it after it works.

1. Make it faster. Cache the setup. Skip the unrelated start up code. Narrow the run to one test.
2. Make the signal sharper. Assert on the exact symptom. Do not assert "it raises no error".
3. Make it deterministic. Pin the clock. Seed the random generator. Isolate the file system. Mock the database. Block the network.

A flaky 30 second loop helps you very little. A deterministic 2 second loop is a superpower.

### Bugs that do not fail on every run

Raise the reproduction rate. The goal here is the rate, not a clean case.

Run the trigger 100 times. Run it in parallel. Add load. Make the timing window smaller. Add sleeps.

You can debug a bug that appears in 50% of runs. You cannot debug a bug that appears in 1% of runs. Raise the rate to 50% first.

### When you cannot build a loop

Stop at phase 1. Then do these three things:

1. Say that you cannot build the loop.
2. List what you tried.
3. Ask for one of these three things:
   - access to the environment that shows the bug
   - a captured artifact, for example a HAR file, a log dump or a screen recording with timestamps
   - permission to add temporary probes to production

Wait for one of them. Phase 3 needs the loop.

### Exit criterion

Name the loop. Run it one time. Show the command and its output. The loop has these four properties:

```
Property         Test
--------         ----
Red capable      It runs the real code path. It asserts the exact symptom.
Deterministic    It gives the same verdict on every run.
Fast             Seconds, not minutes.
Unattended       You can run it without a person in the loop.
```

"It runs without an error" is not red capable. The loop must catch this bug.

Stop and return to step 1 if you read code for a theory before the loop exists. That jump to a theory is the failure this process prevents.

## References

- [diagnosing-bugs skill](https://github.com/mattpocock/skills/blob/9603c1cc8118d08bc1b3bf34cf714f62178dea3b/skills/engineering/diagnosing-bugs/SKILL.md)
