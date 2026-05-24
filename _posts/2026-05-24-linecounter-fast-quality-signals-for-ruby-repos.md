---
layout: post
title: "linecounter: a fast quality read for a Ruby repo"
date: 2026-05-24
last_modified_at: 2026-05-24
author: Robert Hopman
tags: [ruby, gem, code-quality, open-source, tools]
description: A small Ruby gem that scans a git repo and reports per file lines of code, churn, branching, and structure, so you can spot the heavy files fast.
---

I wanted a fast way to read the quality of a Ruby repository, so I wrote a small gem called linecounter.

## Why bother

Most files should not be too long, and most methods should not be too long. A long file is hard to hold in your head, and a long method usually hides more than one job. I wanted a quick signal for that, plus which files change the most and where the branching piles up. Not a full audit, just a first read so I know where to look next.

```bash
gem install linecounter
cd your-ruby-project
linecounter
```

It prints one row per file, sorted so the files that change often and carry the most logic float to the top:

```text
Churn  Branches LOC    File
4      34       189    lib/linecounter/structure_analyzer.rb
4      0        161    test/unit/structure_analyzer_test.rb
3      3        59     test/cli_golden_test.rb
3      1        59     lib/linecounter/cli.rb
```

## How it was built

It started as a single script. To turn it into a gem without breaking anything, I built a safety net first. I pinned the current command line output with golden master tests, so any later change could be compared against a known good result.

Then I used Claude Code to do the real work against that net: extract the script into small classes under `lib`, switch the parsing from regular expressions to the [Prism](https://github.com/ruby/prism) syntax tree for accurate counts, add unit tests, and package the whole thing as a gem. Because the tests pinned behavior before the refactor, the messy middle stayed honest. The output either matched the snapshots or it did not.

The last step was a release to RubyGems.

- Gem: [rubygems.org/gems/linecounter](https://rubygems.org/gems/linecounter)
- Source: [github.com/roberthopman/linecounter](https://github.com/roberthopman/linecounter)
