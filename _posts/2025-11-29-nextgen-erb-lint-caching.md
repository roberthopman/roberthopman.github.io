---
layout: post
title: "Adding ERB Lint Caching to Nextgen"
date: 2025-11-29
last_modified_at: 2025-11-29
author: Robert Hopman
tags: [ruby, rails, performance, open-source]
description: A small contribution to nextgen that enables ERB Lint caching
---

I recently submitted a [pull request](https://github.com/mattbrictson/nextgen/pull/178) to Matt Brictson's nextgen gem. 

## Why Bother

Pre-commit hooks are becoming annoyingly slow when they check all erb files.

ERB Lint caching skips re-analysis of unchanged files. This helps with quicker pre-commit hooks, which will reduce time in local development. Just a flag that was available but not enabled by default.

## The Change

The PR enables ERB Lint's `--cache` flag across the project:

- Adds `--cache` to the erb_lint rake task
- Updates overcommit hooks to use caching
- Adds `.erb_lint_cache` to gitignore

```ruby
# Before
sh "bin/erb_lint --lint-all"

# After
sh "bin/erb_lint --lint-all --cache"
```

## Some Numbers

Looking at the [download stats](https://clickgems.clickhouse.com/dashboard/nextgen), nextgen sees around 284 weekly downloads and has 29K total downloads. That means this small change might save a few seconds here and there for a decent number of projects.

| Metric | Value |
|--------|-------|
| Weekly downloads | ~284 |
| Monthly downloads | ~4,500 |
| Total downloads | 29,000+ |

## Takeaway

If you use a gem regularly and spot something that could be slightly better, consider opening a PR. It doesn't have to be a big feature. Sometimes enabling a flag is enough.

[View the PR on GitHub](https://github.com/mattbrictson/nextgen/pull/178)
