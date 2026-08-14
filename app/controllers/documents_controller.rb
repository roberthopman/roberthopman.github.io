class DocumentsController < ApplicationController
  def show
    @document = Document.find_by_url(request.path)
    raise ActionController::RoutingError, "Not Found" unless @document
  end
end
