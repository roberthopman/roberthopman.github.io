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

## Static Files

Put a static file in `public/`, not in the repo root. Parklife copies
`public/` into the build output verbatim. It does not copy every
front-matter-less file the way Jekyll's `_site` build did. A file placed
outside `public/` and outside a rendered route does not deploy, and the
build raises no error for it.

For example, put a new image at `public/assets/images/example.png`, not at
`assets/images/example.png`.

## Controllers

Use only the seven CRUD actions in a controller: `index`, `show`, `new`,
`create`, `edit`, `update` and `destroy`. A new behaviour gets a new
controller, not a custom action on an existing one.

For example, a search page is `SearchesController#show` at `/search`, not
`PagesController#search`.

`PagesController#home`, `PagesController#archive` and the three actions in
`MachineController` predate this rule. Leave them alone. The rule applies to
new code.

## Build and Test

Build the static site with:

```bash
bin/parklife build
```

This writes the site to `build/`.

Run the test suite with:

```bash
bundle exec ruby test/documents_test.rb
bundle exec ruby test/machine_test.rb
bundle exec ruby test/searches_test.rb
```

All three files must pass before you commit a change to `app/`,
`config/routes.rb` or `config/site.yml`.

## Search

Pagefind reads the built HTML and writes a static index next to it. The app
does not generate it, and `bin/rails server` serves `public/`, not `build/`.
So build the site once and point the index at `public/pagefind/`:

```bash
bin/parklife build && npx --yes pagefind@1.5.2 --site build --output-path public/pagefind
```

Rails then serves the index at `/pagefind/`, and `/search` works in the
development server. The index is a snapshot: run the command again after you
add or edit a post, or the results stay stale. `public/pagefind/` is
gitignored and never committed.

CI runs the same command, without `--output-path`, so the index lands in
`build/` next to the pages it describes. The version is pinned in two places,
here and in `.github/workflows/build.yml`; bump them together. The Node
version itself comes from `.node-version`, the way Ruby comes from
`.ruby-version`.

`public/assets/js/search.js` gates every query, because Pagefind on its own
returns results for a word that appears in no post: it falls back to a shorter
indexed word the query starts with, so "parklife" matches the token "p". The
gate leans on two Pagefind behaviours that a version bump could change, and no
test covers them. A stub test would only check the branching against its own
assumptions; catching a real change of behaviour needs a browser driving the
real index. After you bump the version, run these four queries against
`bin/rails server` and check the answers by hand:

```
Query       Expected
-----       --------
stripe      results, the Stripe post first
stri        results, the Stripe post first (a prefix still matches)
testing     results (the term stems to "tests")
parklife    No results for parklife
```

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
