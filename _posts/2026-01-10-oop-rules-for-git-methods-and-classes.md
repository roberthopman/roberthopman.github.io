---
layout: post
title: "Rule-Based OOP: Git, Methods, Classes"
date: 2026-01-10
excerpt: "A rule-based checklist for software codebases that follow object-oriented programming principles: commit hygiene, method constraints, and class boundaries."
tags: [oop, rules, git, design]
---

This is a rule-based checklist for software codebases that follow object-oriented programming principles. Keep it simple and enforceable.

Each scope gets a hard limit, from the commit down to the line:

![A nested diagram of four rounded boxes, one inside the other. The outer box is the commit: small and frequent, Conventional Commits. Inside it is the class: max 100 lines, few public methods, helpers go private. Inside that is the method: max 5 lines, few arguments, one return type, explicit errors, clear messages. The innermost box, in blue, is the line: max 80 characters.](/assets/images/oop-rules-for-git-methods-and-classes-recap.svg)

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