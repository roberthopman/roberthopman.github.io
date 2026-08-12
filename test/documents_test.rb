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

# A page with no permalink gets a trailing slash, because _config.yml sets
# permalink: /:title/ which ends in a slash.
page = Page.all.find { |doc| doc.path == "ai.md" }
assert_equal("/ai/", page.url, "page url without permalink")

# A page with a permalink uses it verbatim.
tags_page = Page.all.find { |doc| doc.path == "tags.md" }
assert_equal("/tags/", tags_page.url, "page permalink override")

# index.md is the home page.
home = Page.all.find { |doc| doc.path == "index.md" }
assert_equal("/", home.url, "home url")

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

puts "all document assertions passed"
