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

puts "all document assertions passed"
