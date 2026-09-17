class PagesController < ApplicationController
  def home
    @document = view_page(title: nil, url: "/", hide_author: true)
    @posts = Post.all.first(10)
  end

  def archive
    @document = view_page(title: "Archive", url: "/archive/", hide_author: true)
    @range = "all"
    @posts = Post.all
    @tagged_pages = Page.all.select { |page| page.tags.any? }
  end
end
