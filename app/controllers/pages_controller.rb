class PagesController < ApplicationController
  def home
    @document = Page.all.find { |page| page.url == "/" }
  end
end
