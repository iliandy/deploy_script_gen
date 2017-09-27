Rails.application.routes.draw do
  # users routes
  root "users#new"
  post "/users" => "users#create"
  delete "/users/:user_id" => "users#destroy"
  get "/users/:user_id/edit" => "users#edit"
  put "/users/:user_id" => "users#update"
  get "/about" => "users#about"

  # sessions routes
  post "/sessions" => "sessions#create"
  delete "/sessions/:id" => "sessions#destroy"

  # scripts routes
  get "/scripts" => "scripts#index"
  post "/scripts/gen" => "scripts#generate"
  get "/public" => "scripts#download"

  # admins routes
  get "/admins/:id" => "admins#show"
  get "/access/:id/allow" => "admins#allow"
  get "/access/:id/deny" => "admins#deny"

  # unknown routes
  get "*unknown_route", to: redirect("/")

end
