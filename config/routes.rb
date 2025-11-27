Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :playlists, only: [:index, :show, :new, :create] do
    resources :tracks, only: :create
    resources :chats, only: [:create, :new]
  end

  resources :chats, only: :show do
    resources :messages
  end

  # Bookmarks (for liking playlists and following users)
  resources :bookmarks, only: [:create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get '/profile', to: 'users#show', as: :user_profile
end
