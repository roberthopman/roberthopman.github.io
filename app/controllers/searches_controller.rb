class SearchesController < ApplicationController
  # The results come from Pagefind in the browser, so this action only has to
  # hand the layout a page shaped like a Document, exactly as
  # PagesController#archive does. See app/views/searches/show.html.erb.
  def show
    @document = view_page(title: "Search", url: "/search/", hide_author: true)
  end
end
