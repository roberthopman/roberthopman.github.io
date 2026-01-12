---
layout: post
title: "Rule-Based OOP: Git, Methods, Classes"
date: 2026-01-10
excerpt: "A rule-based checklist for software codebases that follow object-oriented programming principles: commit hygiene, method constraints, and class boundaries."
tags: [oop, rules, git, design]
---

This is a rule-based checklist for software codebases that follow object-oriented programming principles. Keep it simple and enforceable.

Git

- Small and frequent commits using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

Line of code:

- Limit lines to 80 characters

Method

- Small methods: 5 lines of code max
- Limit method arguments
- Limit data types of method arguments
- Explicit return of data type
- Return same data type
- Explicit error handling
- Error messages are easy to understand

Class

- Limit amount of public methods
- Add methods in private methods
- Maximum class size is 100 lines of code