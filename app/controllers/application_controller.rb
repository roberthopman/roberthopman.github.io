class ApplicationController < ActionController::Base
  private

  # The shared layout, page header and seo_tags all key off @document
  # (title, url, kind, ...). home, archive and the tag pages are pure
  # views with no backing file, so they hand the layout a page shaped the
  # same way instead of a Document subclass: every value below is exactly
  # what front matter set on the files these views replace (index.md,
  # archive.md, tags.md, and tag_pages.rb's synthetic tag pages).
  ViewPage = Struct.new(:title, :url, :hide_author, keyword_init: true) do
    def kind = :page
    def sidebar = nil
    def description = nil
    def image = Site.image
    def front_matter = {}
    def date = nil
    def last_modified_at = nil
    def tags = []
    def path = nil
    def hide_author? = hide_author
  end

  def view_page(title:, url:, hide_author: false)
    ViewPage.new(title: title, url: url, hide_author: hide_author)
  end
end
