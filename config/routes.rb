Rails.application.routes.draw do
  get 'notifications/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :posts
  root "posts#index"

  resources :users, only: [:index] do
    resources :notifications, only: [:index]
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
