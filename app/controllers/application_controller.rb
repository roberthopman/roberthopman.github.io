class ApplicationController < ActionController::Base
  before_action :reset_document_memoization

  private

  # Post.all/Page.all/Tag.all each memoise for the life of the process (see
  # Document.reset_memo!), which is what keeps `bin/parklife build` fast:
  # eager loading plus no reloading means one process serves the whole
  # crawl, so memoising across it is correct. Development reuses that same
  # long-lived process across requests, so without a reset here the first
  # edit made after boot would memoise forever; clearing once per request,
  # rather than once per call, is what fixed /tags/ calling Post.all and
  # Page.all 190 times (once per tag) instead of twice.
  def reset_document_memoization
    return unless Rails.env.development?

    Post.reset_memo!
    Page.reset_memo!
    Tag.reset_memo!
  end

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
    def hide_last_updated? = false
    def page_title = nil
    def author = nil
  end

  def view_page(title:, url:, hide_author: false)
    ViewPage.new(title: title, url: url, hide_author: hide_author)
  end
end
