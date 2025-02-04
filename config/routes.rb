Rails.application.routes.draw do
  root "dishes#home"

  # Routes pour l'administration
  namespace :admin do
    root "dashboard#index"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :users
    resources :dishes, only: [ :index, :show, :destroy ]
    resources :bookings, only: [ :index, :show, :destroy ]
  end

  # Routes pour les plats
  resources :dishes, only: [ :index, :new, :create, :show, :edit, :update ] do
    collection do
      get :my_dishes
    end
    resources :bookings, only: [ :create ]
    resources :conversations, only: [ :create ]
  end

  # Routes pour les réservations
  resources :bookings, only: [ :index ] do
    member do
      patch :approve
      patch :reject
    end
  end

  # Routes pour les conversations et messages
  resources :conversations, only: [ :index, :show ] do
    resources :messages, only: [ :create ]
  end

  # Routes pour les notifications
  post "/notifications/mark_as_read", to: "notifications#mark_as_read"

  # Routes pour les paramètres
  get "/settings", to: "settings#edit", as: :edit_settings
  patch "/settings", to: "settings#update", as: :settings

  # Routes pour l'authentification
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Routes pour l'inscription
  get "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
