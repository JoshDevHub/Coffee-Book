Rails.application.routes.draw do
  get "profiles/show"
  # Root
  root "posts#index"

  # Users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users, only: %i[index show] do
    resources :notifications, only: [:index]
    resources :friendships, shallow: true, except: %i[new edit update]
    resource :profile, only: %i[edit update]
  end

  # Friendships
  get "users/:id/friends/", to: "friendships#index", as: :friend_list

  # Likes
  concern :likeable do
    resources :likes, shallow: true
  end

  # Posts
  resources :posts do
    resources :comments, shallow: true
    concerns :likeable
  end

  # Friend Requests
  patch "friendships/:id/confirm_request",
        to: "friendships#confirm_request",
        as: "confirm_request"
end
