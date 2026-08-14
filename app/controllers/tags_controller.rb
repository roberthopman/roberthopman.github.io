class TagsController < ApplicationController
  def index
    @document = view_page(title: "Tags", url: "/tags/", hide_author: true)
    # site.tags (posts only), not the plugin's post+page set: a tag used
    # only on a page has a /tags/<slug>/ page but no row here.
    @tags = Tag.all.select { |tag| tag.posts.any? }.sort_by(&:name)
  end

  def show
    @tag = Tag.find_by_slug(params[:slug])
    raise ActionController::RoutingError, "Not Found" unless @tag

    @document = view_page(title: "Tag: #{@tag.name}", url: @tag.url, hide_author: false)
  end
end
