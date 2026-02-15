---
layout: default
title: AI
description: A structured look at the pdca cyle of a coding robot
last_modified_at: 15-02-2026
tags: [ai, prompting, automation]
---

## What a good prompt actually looks like (in practice)

1. **Start with the goal**  
   Clearly state what you want to achieve in one or two sentences.  
   If there are strict requirements or success criteria, mention them right away.

2. **Assign a role only if essential**  
   Only specify a role (e.g. "Act as a senior SRE") if it truly changes how the assistant should respond.  
   Always clarify who the response is for: beginner, expert, manager, etc.

3. **Give relevant context**  
   Share the necessary background or sources for the task (text, links, files, images).  
   Highlight assumptions to treat as true and note anything that's unknown.

4. **Clarify boundaries**  
   Define what the assistant should and shouldn’t do.  
   For example: "No web browsing," "Don’t suggest new tools," "Use a formal tone," etc.

5. **State important rules upfront**  
   Include guidelines, style, legal, or safety constraints early.  
   If some rules are more important than others, mention how to handle conflicts between them.

6. **Describe the approach you want**  
   Instead of just "think step-by-step," ask for:
   - Key assumptions
   - Remaining uncertainties
   - Basic checks or validations
   - Brief rationale for trade-offs  
   Specify when to ask questions versus when to make assumptions.

7. **Define the output format**  
   State clearly:  
   - Required format (section headings, bulleted lists, code, table, JSON, etc.)
   - Length, tone, and language preferences  
   - If you need multiple versions, say how they should differ.

8. **Provide examples when helpful**  
   Include one or two positive examples if you can.  
   Show a quick "don’t do this" example for clarity if certain mistakes should be avoided.

9. **Clarify next steps**  
   Say what should happen after the draft:  
   - Should the assistant ask questions?
   - Suggest improvements?
   - Wait for user edits?
   Only include prior conversation/history if it’s important for interpretation.

10. **Optionally, add a head start**  
    If you have a rough draft or template, share it.  
    This helps the assistant build on your structure instead of starting from scratch.

## Ralph wiggum

Ralph is a Bash loop:

```bash
while :; do cat PROMPT.md | claude-code ; done
```

### References

- [https://ghuntley.com/ralph/](https://ghuntley.com/ralph/)
- [https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [https://www.aihero.dev/getting-started-with-ralph](https://www.aihero.dev/getting-started-with-ralph)
- [https://github.com/snarktank/ralph](https://github.com/snarktank/ralph)
