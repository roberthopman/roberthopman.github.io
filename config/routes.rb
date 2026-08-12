Rails.application.routes.draw do
  root to: "pages#home"

  get "/:slug", to: "documents#show", as: :document
end
