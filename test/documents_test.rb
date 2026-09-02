require_relative "../config/environment"

def assert_equal(expected, actual, label)
  raise "#{label}: expected #{expected.inspect}, got #{actual.inspect}" unless expected == actual
  puts "  ok  #{label}"
end

# Slug and URL come from the filename, with the date stripped.
post = Post.all.find { |doc| doc.path == "_posts/2026-08-09-diagnose-a-bug.md" }
assert_equal("diagnose-a-bug", post.slug, "post slug from filename")
assert_equal("/diagnose-a-bug/", post.url, "post url")
assert_equal(Date.new(2026, 8, 9), post.date.to_date, "post date from filename")

# A front matter permalink wins over the filename.
override = Post.all.find { |doc| doc.path == "_posts/2024-05-04-tools.md" }
assert_equal("/tools-keyboard-shortcuts/", override.url, "post permalink override")

# A page with no permalink gets a trailing slash. See Page#url.
page = Page.all.find { |doc| doc.path == "ai.md" }
assert_equal("/ai/", page.url, "page url without permalink")

# A page with a permalink uses it verbatim.
uses_page = Page.all.find { |doc| doc.path == "uses.md" }
assert_equal("/uses/", uses_page.url, "page permalink override")

# 404.html keeps its extension.
not_found = Page.all.find { |doc| doc.path == "404.html" }
assert_equal("/404.html", not_found.url, "404 url")

# Slugs collide: tools.md and _posts/2024-05-04-tools.md both have the slug
# "tools", but different urls. Resolution must be by url, not slug, or one
# document shadows the other.
tools_page = Document.find_by_url("/tools/")
assert_equal("tools.md", tools_page.path, "resolve /tools/ to the page")

tools_post = Document.find_by_url("/tools-keyboard-shortcuts/")
assert_equal("_posts/2024-05-04-tools.md", tools_post.path, "resolve /tools-keyboard-shortcuts/ to the post")

# 404.html carries no trailing slash, so resolution must also try the path
# as given, not only the path with "/" appended.
not_found_by_url = Document.find_by_url("/404.html")
assert_equal("404.html", not_found_by_url.path, "resolve /404.html to the page")

# An excerpt in front matter wins.
declared = Post.all.find { |doc| doc.front_matter["excerpt"].present? }
assert_equal(declared.front_matter["excerpt"], declared.excerpt_source, "declared excerpt")

# Without one, Jekyll takes the first block delimited by a blank line.
# The expected value is a literal, and the post is named rather than
# searched for. Recomputing the split rule here, or picking "the first post
# without an excerpt", would make the assertion pass even when the rule is
# wrong.
derived = Post.all.find { |doc| doc.path == "_posts/2025-11-29-nextgen-erb-lint-caching.md" }
assert_equal(nil, derived.front_matter["excerpt"], "the fixture declares no excerpt")
assert_equal(
  "I recently submitted a [pull request](https://github.com/mattbrictson/nextgen/pull/178) to Matt Brictson's nextgen gem. ",
  derived.excerpt_source,
  "derived excerpt"
)

# Jekyll::Excerpt#extract_excerpt appends any markdown link reference
# definition ([ref]: url) from the rest of the body that the excerpt's
# own first paragraph actually references, and drops one it doesn't; the
# excerpt would otherwise reuse a reference-style link with no definition
# in reach (tag pages, feed.xml both render "[text][ref]" literally). No
# real post's first paragraph uses a reference-style link, so this is
# exercised with a synthetic body against Document#extract_excerpt
# directly (a private, state-free method: Document.allocate skips
# initialize since nothing here needs a real file on disk).
synthetic_body = <<~BODY.strip
  First paragraph with a [reference link][used].

  Second paragraph, not part of the excerpt.

  [used]: https://example.com/used
  [unused]: https://example.com/unused
BODY
synthetic_excerpt = Document.allocate.send(:extract_excerpt, synthetic_body)
assert_equal(
  "First paragraph with a [reference link][used].\n\n[used]: https://example.com/used",
  synthetic_excerpt,
  "derived excerpt carries a referenced link definition and drops an unreferenced one"
)

seo = Object.new.extend(SeoHelper)

# jekyll-seo-tag truncates the resolved description to
# description_max_words (100 by default) and appends a single "…" (not
# three dots) only when it actually cut something. The longest real
# description in this corpus is far under 100 words, so a synthetic string
# exercises the same private `snippet` method the description path calls.
long_description = (1..105).map { |n| "word#{n}" }.join(" ")
expected_snippet = "#{(1..100).map { |n| "word#{n}" }.join(" ")}…"
assert_equal(expected_snippet, seo.send(:snippet, long_description, 100),
             "long description truncates to 100 words with a single ellipsis")

short_description = "just a few words"
assert_equal(short_description, seo.send(:snippet, short_description, 100),
             "short description under the word limit is left untouched")

# A document's own front-matter author takes priority over the site author
# when resolving the json-ld author name (jekyll-seo-tag's
# AuthorDrop#author_hash). Both posts that declare one happen to share the
# site author's name, so this pins the resolved value as a regression
# guard rather than proving document-over-site precedence on its own; see
# json_ld_author_name's own comment for that rule.
authored_post = Post.all.find { |doc| doc.front_matter["author"] == "Robert Hopman" }
assert_equal("Robert Hopman", seo.send(:json_ld_author, authored_post)["name"],
             "json-ld author name for a post with its own front-matter author")

# Tag replaces _plugins/tag_pages.rb. A multi-word tag slugifies with a
# hyphen, same as Jekyll's Utils.slugify.
git_grep = Tag.find_by_slug("git-grep")
assert_equal("git grep", git_grep.name, "multi-word tag slug")

# "security" is declared only on iso-27001.md, a page, and on no post.
# Tag.all must still find it (tag_pages.rb generated a page for every tag
# on a post OR a page), but the /tags/ index only lists tags with a post
# (site.tags is posts only), so it must report zero posts here.
security = Tag.find_by_slug("security")
assert_equal([], security.posts, "a page-only tag has no posts")
assert_equal(["iso-27001.md"], security.pages.map(&:path), "a page-only tag still resolves its page")

# Two spellings of the same tag collapse to one Tag, keyed by slug, first
# spelling wins. No tag in the real corpus has two spellings, so an
# assertion pinned to Tag.all would pass even with the dedup logic
# removed; Tag.build_from is the exact code Tag.all calls, exercised here
# with synthetic documents so the rule is genuinely tested.
FakeTaggedDocument = Struct.new(:tags)
dedup_input = [
  FakeTaggedDocument.new(["Git Grep"]),
  FakeTaggedDocument.new(["git grep"]),
  FakeTaggedDocument.new(["Ruby"])
]
deduped = Tag.build_from(dedup_input)
assert_equal(2, deduped.size, "two spellings of one tag collapse to a single Tag")
assert_equal("Git Grep", deduped.find { |tag| tag.slug == "git-grep" }.name,
             "the first spelling encountered wins the dedup")

# Document.all (see Post.all/Page.all) memoises per class for the life of
# the process; ApplicationController resets that memo once per request in
# development. Pin the contract directly: two calls within the same
# "request" hand back the identical parsed instance, not two separate
# reads of the file from disk. Post.all itself always returns a new Array
# (it wraps Document.all in a sort_by.reverse), so the identity check is
# on an element, the thing that is actually expensive to reconstruct.
memoised_path = "_posts/2026-08-09-diagnose-a-bug.md"
first_call = Post.all.find { |doc| doc.path == memoised_path }
second_call = Post.all.find { |doc| doc.path == memoised_path }
assert_equal(true, first_call.equal?(second_call),
             "two Post.all calls hand back the identical document instance while memoised")

# Prove the identity check above is not a tautology (identity by
# coincidence). Mutate the memoised instance in place, exactly like a
# saved edit would produce, and confirm the mutation is visible on the
# next call too: without a reset, Post.all really is handing back the
# same object.
original_title = first_call.front_matter["title"]
first_call.front_matter["title"] = "MUTATED"
assert_equal("MUTATED", Post.all.find { |doc| doc.path == memoised_path }.front_matter["title"],
             "without a reset, Post.all keeps handing back the same (now mutated) instance")

# Post.reset_memo! is what ApplicationController calls once per request in
# development. After it, the next Post.all call reparses the file from
# disk: the in-memory mutation is gone, the real title is back, and the
# instance itself is a new one, not the mutated one restored in place.
Post.reset_memo!
restored = Post.all.find { |doc| doc.path == memoised_path }
assert_equal(original_title, restored.front_matter["title"],
             "Post.reset_memo! clears the memo: the next call reparses the file from disk")
assert_equal(false, first_call.equal?(restored),
             "the post after reset is a freshly parsed instance, not the mutated one restored in place")

# Document#word_count is what archive.html.erb's data-words attribute
# calls (see Document#word_count and app/views/pages/archive.html.erb).
# data-words is stripped from the parity comparison, so a wrong count
# ships silently unless it is pinned here directly. These are the counts
# captured from the real dev server before WORD_COUNT_CACHE existed;
# recomputing the split rule here would let a broken cache still pass.
diagnose_a_bug = Post.all.find { |doc| doc.path == "_posts/2026-08-09-diagnose-a-bug.md" }
assert_equal(1218, diagnose_a_bug.word_count, "word count: diagnose-a-bug")

drawing_svg = Post.all.find { |doc| doc.path == "_posts/2026-05-31-drawing-open-circular-cycle-diagrams-in-svg.md" }
assert_equal(2391, drawing_svg.word_count, "word count: drawing-open-circular-cycle-diagrams-in-svg")

erb_lint_caching = Post.all.find { |doc| doc.path == "_posts/2025-11-29-nextgen-erb-lint-caching.md" }
assert_equal(223, erb_lint_caching.word_count, "word count: nextgen-erb-lint-caching")

ai_page = Page.all.find { |doc| doc.path == "ai.md" }
assert_equal(384, ai_page.word_count, "word count: ai.md")

iso_page = Page.all.find { |doc| doc.path == "iso-27001.md" }
assert_equal(3756, iso_page.word_count, "word count: iso-27001.md")

ruby_syntax_page = Page.all.find { |doc| doc.path == "ruby-syntax.md" }
assert_equal(22281, ruby_syntax_page.word_count, "word count: ruby-syntax.md")

# WORD_COUNT_CACHE is keyed by path AND mtime (see Document#word_count), so
# editing a file invalidates only that file's entry with no server
# restart. A real post is never touched to prove this: a temporary
# fixture file stands in, written and deleted here, under tmp/ (gitignored,
# outside _posts/ and Page.glob, so nothing else ever scans it).
require "fileutils"

temp_relative_path = "tmp/word_count_cache_test.md"
temp_full_path = Rails.root.join(temp_relative_path)
begin
  # tmp/ is gitignored and empty, so it does not exist in a fresh checkout.
  # CI failed here before this line was added.
  FileUtils.mkdir_p(File.dirname(temp_full_path))
  File.write(temp_full_path, "---\ntitle: Word Count Cache Test\n---\nOne two three four five.\n")
  first_count = Document.new(temp_relative_path).word_count
  assert_equal(5, first_count, "temporary fixture: initial word count")

  # A new Document instance mirrors what Post.reset_memo! hands back each
  # development request: a fresh parse of the same path. Without mtime
  # invalidation this would still read the first_count value from the
  # cache instead of recomputing.
  unchanged_reread = Document.new(temp_relative_path).word_count
  assert_equal(5, unchanged_reread, "temporary fixture: unchanged mtime reuses the cached count")

  File.write(temp_full_path, "---\ntitle: Word Count Cache Test\n---\nOne two three four five six seven.\n")
  FileUtils.touch(temp_full_path, mtime: Time.now + 5)

  changed_count = Document.new(temp_relative_path).word_count
  assert_equal(7, changed_count, "temporary fixture: a changed mtime invalidates the cache and recomputes")
ensure
  File.delete(temp_full_path) if File.exist?(temp_full_path)
end

# Pagefind indexes only the elements marked data-pagefind-body, and skips a
# page carrying none. That single attribute is what keeps the header, the
# footer, the sidebar, the tag pages and the archive out of the results, so
# it has to be on both branches of documents/show: a post's .post-content,
# and a page's otherwise unwrapped body.
post_html = ApplicationController.render(template: "documents/show", layout: false,
                                         assigns: { document: post })
assert_equal(true, post_html.include?("data-pagefind-body"), "a rendered post marks its body for pagefind")

page_html = ApplicationController.render(template: "documents/show", layout: false,
                                         assigns: { document: page })
assert_equal(true, page_html.include?("data-pagefind-body"), "a rendered page marks its body for pagefind")

# 404.html is a Page like any other, so without the sitemap flag it would
# rank in its own search results.
not_found_html = ApplicationController.render(template: "documents/show", layout: false,
                                              assigns: { document: not_found })
assert_equal(false, not_found_html.include?("data-pagefind-body"),
             "a page declaring sitemap: false stays out of the search index")

puts "all document assertions passed"
