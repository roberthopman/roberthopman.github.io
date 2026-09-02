require_relative "../config/environment"

def assert_equal(expected, actual, label)
  raise "#{label}: expected #{expected.inspect}, got #{actual.inspect}" unless expected == actual
  puts "  ok  #{label}"
end

# /search is a CRUD show action on its own controller, not a custom action on
# PagesController (see AGENTS.md, "Controllers").
route = Rails.application.routes.recognize_path("/search")
assert_equal("searches", route[:controller], "/search routes to the searches controller")
assert_equal("show", route[:action], "/search routes to a show action")

# The page ships its own front end rather than Pagefind's Default UI, which
# renders Pagefind's fallback matches as ordinary results (see
# public/assets/js/search.js). The script is a module because it imports
# /pagefind/pagefind.js, which the build generates.
html = ApplicationController.render(template: "searches/show", layout: false)
assert_equal(true, html.include?('<script type="module" src="/assets/js/search.js">'),
             "search page loads its front end as a module")

# The stylesheet is site-wide now, because the header box uses it too.
head = ApplicationController.render(partial: "layouts/head",
                                    assigns: { document: ApplicationController::ViewPage.new(title: "Search", url: "/search/") })
assert_equal(true, head.include?("/assets/css/search.css"), "the search stylesheet is linked site-wide")
assert_equal(false, html.include?("pagefind-ui"), "search page does not fall back to the pagefind default ui")

# An input with no label is unusable with a screen reader, and the visible
# heading is not one.
assert_equal(true, html.include?('<label class="search-label" for="search-input">'),
             "the search input carries a label")

# Pagefind is the only search path, so a reader without JavaScript gets
# nothing unless the view hands them somewhere else to go.
assert_equal(true, html.include?("<noscript>"), "search page has a noscript fallback")
assert_equal(true, html.include?("/archive/"), "the noscript fallback links to the archive")

# The header carries the search box on every page but /search/ itself, which
# has its own. Two boxes would be two search landmarks and two tab stops.
def header_for(url)
  ApplicationController.render(partial: "layouts/header",
                               assigns: { document: ApplicationController::ViewPage.new(title: nil, url: url) })
end

assert_equal(true, header_for("/archive/").include?('action="/search/"'),
             "the header carries a search form")
assert_equal(true, header_for("/archive/").include?('<label class="search-label" for="header-search">'),
             "the header search input carries a label")
assert_equal(false, header_for("/search/").include?('action="/search/"'),
             "the search page does not repeat the form in its header")

# The submit control is an icon, so its only accessible name is the aria-label.
assert_equal(true, header_for("/archive/").include?('<button type="submit" class="site-search__submit" aria-label="Search">'),
             "the header search form has a named submit button")

# The box replaced the nav link, so nothing should still resolve search.md.
assert_equal(false, Site.header_pages.include?("search.md"), "the redundant search nav link is gone")

puts "all search assertions passed"
