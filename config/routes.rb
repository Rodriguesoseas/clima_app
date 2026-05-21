Rails.application.routes.draw do
  root "weather#index"

  get  "/login",  to: "sessions#new",     as: :login
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/buscar_clima", to: "weather#buscar", as: :buscar_clima

  get "up" => "rails/health#show", as: :rails_health_check
end

