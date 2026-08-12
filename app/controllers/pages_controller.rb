class PagesController < ApplicationController
  def home
    @document = Page.find_by_slug("index")
  end
end
