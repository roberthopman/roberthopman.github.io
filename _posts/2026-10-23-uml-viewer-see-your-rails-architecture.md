---
layout: post
title: "uml-viewer: see the architecture of a Rails app in the browser"
date: 2026-10-23
last_modified_at: 2026-10-23
author: Robert Hopman
tags: [ruby, rails, gem, architecture, uml, claude-code, open-source, tools]
description: A Ruby gem that shows a Ruby or Rails project as a live UML diagram. See the structure, find the dependencies that point the wrong way, and try a new architecture before you change the code.
---

Based on the ideas of [uml-viewer](https://github.com/unclebob/uml-viewer) by Robert C. Martin (Uncle Bob), a tool for Clojure. My version brings them to Ruby and Rails.

## What you can do with it

- **See the structure as it is.** Double-click to go from a folder to its classes, to a class card, to the source lines.
- **Find the wrong dependencies.** A model that calls a service or starts a job breaks the Dependency Rule, so its arrow is red.
- **See where the tests are weak.** After a SimpleCov run, complex code with few tests shows as a red box.
- **Play what-if games.** Describe a new architecture, and the diagram shows your code in that form before you change a line. Try again until you like it, then ask Claude Code to make the code match.
- **Let Claude Code help.** Right-click a class to have Claude explain it or hide it from the diagram.

The viewer writes nothing into your project, so you can also look at the code of another team.

## How to use it

```bash
gem install uml-viewer
uml-viewer install-skill
uml-viewer path/to/your/project
```

Then start Claude Code in the same project and tell it that uml-viewer runs.

- Gem: [rubygems.org/gems/uml-viewer](https://rubygems.org/gems/uml-viewer)
- Source: [github.com/roberthopman/uml-viewer](https://github.com/roberthopman/uml-viewer)
