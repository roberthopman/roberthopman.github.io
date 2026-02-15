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

### list files

```bash
# list files
ls

# long listing of files and directories
ll

# show the alias for ll
type -a ll   
=> ll is an alias for ls -lh
```

```bash
# list all files and directories, typically an alias for ls -a
la
# show the alias for la
type -a la   
la is an alias for ls -lAh
```

### bash & zsh

Further reading on Bourne-Again SHell and Z Shell.
- [Bourne-Again SHell](https://en.wikipedia.org/wiki/Bourne-Again_Shell)
- [Z Shell](https://en.wikipedia.org/wiki/Z_shell)


```bash
# show the man page for ls
man ls

# show the man page for man
man man

# show the man page for bash
man bash

# show the man page for zsh
man zsh
```

That's it for now.