require_relative "../config/environment"

def assert_equal(expected, actual, label)
  raise "#{label}: expected #{expected.inspect}, got #{actual.inspect}" unless expected == actual
  puts "  ok  #{label}"
end

# ApplicationController.helpers is Rails' own helper proxy: every app/helpers
# module (MachineHelper included) mixed in alongside the real Action View
# helpers (strip_tags) MachineHelper calls internally. A bare
# Object.new.extend(MachineHelper) raises on strip_tags, because
# ActionView::Helpers::SanitizeHelper#strip_tags calls self.class.full_sanitizer,
# a class-level method a plain extend never provides.
helpers = ApplicationController.helpers

# A feed entry's <id> is the post's absolute URL with its trailing slash
# chomped (Jekyll's post.id has none); <link href> is the ordinary absolute
# URL, which keeps it. Losing the chomp would make both identical.
post = Post.all.find { |doc| doc.path == "_posts/2026-08-09-diagnose-a-bug.md" }
entry = helpers.feed_entry_xml(post)
id = entry[/<id>([^<]+)<\/id>/, 1]
link_href = entry[/<link href="([^"]+)"/, 1]
assert_equal(false, id.end_with?("/"), "feed entry <id> carries no trailing slash")
assert_equal(true, link_href.end_with?("/"), "feed entry <link href> carries a trailing slash")
assert_equal(link_href.chomp("/"), id, "the two agree once the trailing slash is accounted for")

# xml_escape matches Jekyll's xml_escape filter (REXML's
# String#encode(xml: :attr)), not Rails' own HTML escaping: both escape "&"
# and "<", so this also guards against a stray double-escape.
assert_equal("AT&amp;T &lt; Verizon", helpers.xml_escape("AT&T < Verizon"), "xml_escape escapes & and <")

# smartify is Jekyll's SmartyPants-only Kramdown parser (typography, not
# markdown): a straight apostrophe becomes a curly one, but "*args" and
# "`code`" are not emphasis/code-span syntax under this parser and must
# come out exactly as written. Run through the full-markdown renderer this
# used to call, "*args and `code`" would become "<em>args and </em>code<code>"
# or similar, and this assertion is the regression guard for that.
smart_title = helpers.smartify("Using *args and `code` isn't slow in Ruby")
assert_equal("Using *args and `code` isn’t slow in Ruby", smart_title, "smartify: curly quote, markdown control characters left literal")
assert_equal(false, smart_title.include?("<"), "smartify never introduces markup for *, ` or [] in a title")

# llms.txt's "## Pages" section only lists a page with a title (mirrors
# jekyll's own "{%- if p.title -%}"). 404.html declares none.
# MachineController#llms_pages is the real filter the controller action
# calls; calling it here (rather than re-deriving "select { |page|
# page.title.present? }" locally) is what sitemap_page_urls below already
# does for sitemap.xml, so a change to the real filter can't drift
# unnoticed from what this assertion checks.
not_found = Page.all.find { |doc| doc.path == "404.html" }
assert_equal(nil, not_found.title, "404.html declares no title")
pages_for_llms = MachineController.new.send(:llms_pages)
assert_equal(false, pages_for_llms.include?(not_found), "the llms.txt page filter excludes a page with no title")
assert_equal(false, helpers.llms_txt(pages_for_llms, []).include?("404"), "404.html's own text never reaches llms.txt output")

# sitemap.xml's page loop only includes a page whose front matter does not
# set "sitemap: false" (mirrors jekyll's own "page.sitemap != false").
# 404.html sets it explicitly.
assert_equal(false, not_found["sitemap"], "404.html declares sitemap: false")
sitemap_urls = MachineController.new.send(:sitemap_page_urls)
assert_equal(false, sitemap_urls.include?(not_found.url), "sitemap.xml excludes a document with sitemap: false")

puts "all machine assertions passed"
