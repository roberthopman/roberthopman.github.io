---
layout: post
title:  "Moving from GitLab to GitHub"
date: 2026-01-09
excerpt: "Notes on migrating from GitLab to GitHub while maintaining history, including user mapping, commits, issues, and more."
tags: [git, migration, gitlab, github]
---

I've migrated from gitlab to github in 2021 which had some issues: [https://github.com/piceaTech/node-gitlab-2-github/issues/99](https://github.com/piceaTech/node-gitlab-2-github/issues/99)

The whole move, from the GitLab API to the GitHub API, in one tool:

![An architecture diagram with three boxes in a row. GitLab on the left is the source. The node-gitlab-2-github tool in the middle is the focal box and lists what it carries: users, commits, projects, issues, labels, milestones, merge requests and attachments. GitHub on the right is the target. One arrow reads from the GitLab API into the tool, and a second arrow writes from the tool into the GitHub API.](/assets/images/migrate-gitlab-to-github-recap.svg)

Most important was maintaining the history, so that included:

- user mapping
- commit mapping
- project mapping
- attachments
- issue information
- descriptions, labels, milestones, merge requests

Tool used: [https://github.com/piceaTech/node-gitlab-2-github](https://github.com/piceaTech/node-gitlab-2-github)

Have fun.
