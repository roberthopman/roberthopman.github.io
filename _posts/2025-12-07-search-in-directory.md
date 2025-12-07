---
layout: post
title:  "Search in a repo"
excerpt: "Quick reference for searching files and content in a directory using grep, git grep, ripgrep and find."
tags: [terminal, grep, git grep, ripgrep, find]
---

You can search for a word in a repo using several command line tools.

### grep

```bash
# Searches in a single file only
grep "search_term" filename

# Recursive search, search in the directory and all files in it and its subdirectories
grep -r "search_term" directory

# Case insensitive
grep -ri "search_term" directory

# Show line numbers
grep -rn "search_term" directory
```

### git grep (tracked files only)

```bash
git grep "search_term"
```

### find (by filename)

```bash
# Find files by name
find . -name "*.rb"

# Find files containing text in name
find . -name "*controller*"
```

### ripgrep (rg)

Ripgrep is a faster grep tool.

```bash
# Search for a word
rg "search_term"

# Case insensitive
rg -i "search_term"

# Show line numbers
rg -n "search_term"

# Show line numbers and context
rg -C 3 "search_term"
```

That's it for now.