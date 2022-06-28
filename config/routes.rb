Rails.application.routes.draw do
  # Users
  devise_for :users
  resources :users, only: [:index] do
    resources :notifications, only: [:index]
  end

  # Posts
  resources :posts
  root "posts#index"

  # Friend Requests
  resources :friend_requests, only: %i[show destroy]
  patch "friend_requests/:id/confirm_request",
        to: "friend_requests#confirm_request",
        as: "confirm_request"
end
