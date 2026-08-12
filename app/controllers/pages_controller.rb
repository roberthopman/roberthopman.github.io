class PagesController < ApplicationController
  def home
    @document = view_page(title: nil, url: "/", hide_author: true)
    @posts = Post.all.first(10)
  end

  def archive
    @document = view_page(title: "Archive", url: "/archive/", hide_author: true)
    # archive.md computed "now - 15552000 seconds", which is 180 days, not
    # the 18 months its own variable name claimed.
    @cutoff = Time.now.utc - 15_552_000
    @tagged_pages = Page.all.select { |page| page.tags.any? }
  end
end
