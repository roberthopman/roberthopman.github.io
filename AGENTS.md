Instructions for all AI agents working on this project.

## Development Server

Run the local development server with:

```bash
bin/rails server
```

Pages render on request. Editing a post and refreshing the browser is enough;
there is no build step.

To work on styles, run the Sass compiler in a second terminal:

```bash
npx sass --watch --load-path=_sass _sass/style.scss public/assets/css/style.css
```

This produces uncompressed CSS for fast iteration. Before committing a style
change, recompile once with `--style=compressed` so
`public/assets/css/style.css` matches the asset the build ships.

## Tutorial Writing Checklist

When writing or reviewing blog posts that are tutorials (step-by-step guides, how-tos), check against these rules. 

Source: [Rules for Software Tutorials](https://refactoringenglish.com/chapters/rules-for-software-tutorials/)

1. **Write for beginners** — No unexplained jargon; a newcomer can follow along
2. **Promise a clear outcome in the title** — Title says what the reader will build or achieve
3. **Explain the goal in the introduction** — Opening answers "why should I care?" and "is this for me?"
4. **Show the end result** — Demo, screenshot, or output shown early
5. **Make code snippets copy/pasteable** — No shell prompts ($) in copyable blocks; use non-interactive flags; chain with &&
6. **Use long command-line flags** — `--recursive` not `-r`
7. **Separate user-defined values** — Use variables or constants for values the reader must change; comment what to customize
8. **Use unambiguous example values** — Example data is obviously example data, not confusable with syntax
9. **Spare the reader from mindless tasks** — Automate tedious steps with commands instead of manual instructions
10. **Keep code in a working state** — Each intermediate step compiles/runs; use stubs if needed
11. **Teach one thing** — One concept per tutorial; defer secondary topics
12. **Don't try to look pretty** — Minimal styling; clarity over aesthetics
13. **Minimize dependencies** — Avoid unnecessary libraries; pin versions when used
14. **Specify filenames clearly** — Full file paths; indicate where in the file to add code
15. **Use consistent, descriptive headings** — Clear hierarchy; consistent casing and verb tense
16. **Demonstrate that the solution works** — Show verification output or screenshot proving success
17. **Link to a complete example** — Provide a repo or gist with the full working code
