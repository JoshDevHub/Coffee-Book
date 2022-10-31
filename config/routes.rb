Rails.application.routes.draw do
  # Root
  root "posts#index"

  # Auth
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               registrations: "users/registrations",
               sessions: "users/sessions"
             }

  # Users
  resources :users, only: %i[index] do
    resources :friendships, shallow: true, only: %i[create destroy]
  end

  get "user/:username", to: "users#show", as: :user

  # Friendships
  get "users/:username/friends", to: "friendships#index", as: :user_friends

  # Profile
  get "profile/edit", to: "profiles#edit", as: :edit_profile
  patch "profile", to: "profiles#update", as: :profile

  # Notifications
  resources "notifications", only: %i[index]

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
