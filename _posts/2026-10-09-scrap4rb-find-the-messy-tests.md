---
layout: post
title: "scrap4rb: find the messy tests in a Ruby project"
date: 2026-10-09
last_modified_at: 2026-10-09
author: Robert Hopman
tags: [ruby, gem, testing, minitest, code-quality, open-source, tools]
description: A small Ruby gem that reads your Minitest tests and points at the ones that are too long, check too little, or fake too much.
---

Tests are code too, and they can get messy. I wanted a quick way to find the messy tests in a Ruby project, so I wrote a small gem called scrap4rb.

It copies the rules of [SCRAP](https://github.com/unclebob/scrap), a tool by Robert C. Martin (Uncle Bob) for Clojure tests. scrap4rb brings those rules to Ruby and Minitest.

What scrap4rb does with your tests:

![A diagram with four boxes in one chain. A Test files box on the left feeds a zone named scrap4rb. Inside it, Each test gives every test its smells, branches and a score, and feeds Whole file, which adds up the totals and finds tests that look alike. Whole file feeds one highlighted box on the right, Advice per file: leave it, fix some tests, make a table, or split the file.](/assets/images/scrap4rb-find-the-messy-tests-recap.svg)

## Why bother

There are good Ruby tools that score code: [flog](https://github.com/seattlerb/flog), [flay](https://github.com/seattlerb/flay), [reek](https://github.com/troessner/reek) and [rubycritic](https://github.com/whitesmith/rubycritic). But they look at a test as if it were normal code, and that gives strange results:

- reek does not see a `test "..." do` block at all, because it is not a method.
- rubycritic says "long is bad". A test that is long because it checks many things gets a D.
- A test that clicks "Save" a second time when the first click did not work gets an A. That test can hide a real bug, but a score for normal code cannot see it.

scrap4rb asks other questions. Does the test check anything? Does it do one thing? Does it fake a lot? Does it hide work in helpers? Each "no" gives the test a smell:

```text
Smell                      In plain words
-----                      --------------
no-assertions              the test checks nothing
low-assertion-density      the test is long, but checks only one thing
multiple-phases            the test does something, checks, does more, checks again
high-mocking               the test fakes more than 3 things
large-example              the test is longer than 20 lines
helper-hidden-complexity   the helpers it calls hide more than 8 lines of work
temp-resource-work         the test makes temp files or folders
literal-heavy-setup        the test carries a big block of data
```

An `if`, a loop or a rescue inside a test also makes its score worse, because a test with choices in it can take a different path each time.

scrap4rb also looks for tests that are almost the same. When three tests differ only in one number, it says: make one table with three rows.

At the end, it gives one piece of advice per file: leave it, fix some tests, make a table, or split the file.

## How to use it

```bash
gem install scrap4rb
cd your-ruby-project
scrap4rb
```

It shows the files that need the most work first, and in each file the worst tests first:

```text
test/models/smelly_test.rb
  score 48.46 HIGH  mode LOCAL  ai AUTO_REFACTOR  tests=6 avg=12.78 max=18.26
  HIGH   Strengthen assertions in weak tests before doing structural cleanup.
   18.3  L59   it uses a long local helper            low-assertion-density,helper-hidden-complexity
   17.3  L35   it handles a large payload             low-assertion-density,literal-heavy-setup
   12.3  L13   it syncs everything through the api    high-mocking
   11.0  L8    it saves the record                    no-assertions
```

How to read it: this file needs work, and the advice is to fix the tests where they are. The worst test, on line 59, checks too little and hides work in a long helper. The test on line 8 checks nothing at all.

This output comes from the sample tests in the scrap4rb repository, so you can run it yourself.

Did your change make the tests better or worse? Save a score before the change, and compare after it:

```bash
scrap4rb --write-baseline tmp/scrap.json
# change the tests
scrap4rb --compare tmp/scrap.json
```

The advice is a place to look, not an order. Read the test before you change it.

## How it was built

I built it the same way as [linecounter](/linecounter-fast-quality-signals-for-ruby-repos/):

1. It started as [one script](https://github.com/roberthopman/scrap4rb/blob/fbe3fa96ee91b9f51d2ba53a09543f1f663bc963/lib/scrap4rb.rb).
2. I saved the output of that script on a set of sample tests. Those saved results are the safety net: later changes must give the same output.
3. Claude Code wrote a small test for each rule, right at its limit. For example, a test of 20 lines is fine and a test of 21 lines is too long. These tests failed first.
4. To make them pass, Claude Code split the script into small parts, the same parts as in SCRAP.

The last step was a release to RubyGems.

- Gem: [rubygems.org/gems/scrap4rb](https://rubygems.org/gems/scrap4rb)
- Source: [github.com/roberthopman/scrap4rb](https://github.com/roberthopman/scrap4rb)
- SCRAP: [github.com/unclebob/scrap](https://github.com/unclebob/scrap)
