Rails.application.routes.draw do
  get "profiles/show"
  # Root
  root "posts#index"

  # Users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users, only: %i[index show] do
    resources :notifications, only: [:index]
    resources :friendships, shallow: true, except: %i[new edit update show]
    resource :profile, only: %i[edit update]
  end

  # Friendships
  get "users/:id/friends/", to: "friendships#index", as: :friend_list

  resources :likes, only: %i[create destroy]

  # Posts
  resources :posts do
    resources :comments, shallow: true
  end

  # Friend Requests
  patch "friendships/:id/confirm_request",
        to: "friendships#confirm_request",
        as: "confirm_request"
end
