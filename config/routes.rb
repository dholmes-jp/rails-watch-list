Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "lists", to: "lists#index", as: :lists
  get "lists/new", to: "lists#new", as: :new_list
  post "lists", to: "lists#create"
  get "lists/:id", to: "lists#show", as: :list
  get "lists/:list_id/bookmarks/new", to: "bookmarks#new", as: :new_list_bookmark
  post "lists/:list_id/bookmarks", to: "bookmarks#create", as: :list_bookmarks
  delete "bookmarks/:id", to: "bookmarks#destroy", as: :bookmark
end
