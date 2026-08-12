class MachineController < ApplicationController
  layout false

  # Pages that were never Page objects to begin with: home, archive and
  # tags moved to pure views in an earlier task (see
  # ApplicationHelper::HEADER_VIRTUAL_PAGES), so sitemap.xml's own
  # alphabetical page order is reconstructed by sorting them back in by
  # slug alongside the real Page documents.
  VIRTUAL_SITEMAP_PAGES = { "archive" => "/archive/", "index" => "/", "tags" => "/tags/" }.freeze

  def feed
    @posts = Post.all
    render formats: [:atom], content_type: "application/atom+xml"
  end

  def sitemap
    @posts = Post.all
    @page_urls = sitemap_page_urls
    render formats: [:xml], content_type: "application/xml"
  end

  def llms
    @pages = Page.all.select { |page| page.title.present? }
    @posts = Post.all
    render formats: [:text], content_type: "text/plain"
  end

  private

  def sitemap_page_urls
    real = Page.all.select { |page| page["sitemap"] != false }.map { |page| [page.slug, page.url] }
    ordered = (real + VIRTUAL_SITEMAP_PAGES.to_a).sort_by(&:first).map(&:last)
    ordered + sitemap_tag_urls
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
