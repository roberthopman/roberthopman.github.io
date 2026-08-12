Rails.application.routes.draw do
  root to: "pages#home"

  get "/archive", to: "pages#archive"
  get "/tags", to: "tags#index"
  get "/tags/:slug", to: "tags#show"

  # format: false stops Rails treating the ".html" in "/404.html" as a format
  # extension, which would otherwise route it as slug=404, format=html and
  # leave DocumentsController looking up a url that does not exist. A dynamic
  # segment's default regexp also excludes ".", format or not, so the
  # constraint has to say the segment may contain one.
  get "/:slug", to: "documents#show", as: :document, format: false, constraints: { slug: /[^\/]+/ }
end
