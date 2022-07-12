Rails.application.routes.draw do
  get "profiles/show"
  # Root
  root "posts#index"

  # Users
  devise_for :users
  resources :users, only: [:index] do
    resources :notifications, only: [:index]
    resources :friendships, shallow: true
    resource :profile
  end

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
