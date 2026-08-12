class DocumentsController < ApplicationController
  def show
    @document = Post.find_by_slug(params[:slug]) || Page.find_by_slug(params[:slug])
    raise ActionController::RoutingError, "Not Found" unless @document
  end
end
