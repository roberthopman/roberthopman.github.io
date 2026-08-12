class MachineController < ApplicationController
  layout false

  # Pages that were never Page objects to begin with: home, archive and
  # tags moved to pure views in an earlier task (see
  # ApplicationHelper::HEADER_VIRTUAL_PAGES), so sitemap.xml.liquid's own
  # alphabetical site.pages order is reconstructed by sorting them back in
  # by slug alongside the real Page documents.
  VIRTUAL_SITEMAP_PAGES = { "archive" => "/archive/", "index" => "/", "tags" => "/tags/" }.freeze

  # Where master's site.pages carried a page that fails sitemap.xml's own
  # {% if %} (confirmed with a one-off Jekyll :post_write hook dumping
  # site.pages, see task-8-report.md): llms.txt and the Sass entry point
  # for main.css between "iso-27001" and "ruby-syntax", then sitemap.xml
  # and the Sass entry point for the theme stylesheet between "ruby-syntax"
  # and "tags". Keyed by the slug the skip run comes immediately after.
  SITEMAP_SKIPS_AFTER = { "iso-27001" => 2, "ruby-syntax" => 2 }.freeze

  def feed
    @posts = Post.all
    render formats: [:atom], content_type: "application/atom+xml"
  end

  def sitemap
    @posts = Post.all
    @page_entries = sitemap_page_entries
    render formats: [:xml], content_type: "application/xml"
  end

  def llms
    @pages = Page.all.select { |page| page.title.present? }
    @posts = Post.all
    render formats: [:text], content_type: "text/plain"
  end

  private

  # Builds the same :skip / [:page, url] token sequence master's
  # site.pages carried through sitemap.xml.liquid's page loop, so
  # MachineHelper#sitemap_xml can render each token's turn without needing
  # to know why a given position is empty.
  def sitemap_page_entries
    real = Page.all.select { |page| page["sitemap"] != false }.map { |page| [page.slug, page.url] }
    ordered = (real + VIRTUAL_SITEMAP_PAGES.to_a).sort_by(&:first)

    entries = [:skip] # 404.html: sitemap: false, sorts before every page above
    ordered.each do |slug, url|
      entries << [:page, url]
      SITEMAP_SKIPS_AFTER.fetch(slug, 0).times { entries << :skip }
    end
    sitemap_tag_urls.each { |url| entries << [:page, url] }
    2.times { entries << :skip } # feed.xml, and the Sass source-map companion it beat to /assets/main.css
    entries
  end

  # _plugins/tag_pages.rb built site.tags in the order tags first appear
  # while walking "site.posts.docs + site.pages" (posts oldest to newest,
  # the collection's natural sort, not Post.all's newest-first display
  # order), and site.pages preserves whatever order a Hash's keys were
  # inserted in. Tag.all sorts its own return value by slug for the /tags/
  # index, so that order is rebuilt here instead of read off the model.
  def sitemap_tag_urls
    tags_by_slug = Tag.all.index_by(&:slug)
    seen = {}
    slugs = []
    (Post.all.reverse + Page.all).each do |document|
      document.tags.each do |raw|
        slug = raw.to_s.strip.parameterize
        next if slug.empty? || seen[slug]

        seen[slug] = true
        slugs << slug
      end
    end
    slugs.map { |slug| tags_by_slug.fetch(slug).url }
  end
end
