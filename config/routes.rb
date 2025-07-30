Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: ->(env) { [ 200, { "Content-Type" => "application/json" }, [ '{"message":"API online"}' ] ] }
  namespace :api do
    post "register", to: "registrations#create"
    post "login", to: "sessions#create"
    get "validate", to: "sessions#validate"
    resources :pueblo_magicos
  end
end
