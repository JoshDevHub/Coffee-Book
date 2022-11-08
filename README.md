# Coffee Book

A social media clone app for people who love coffee.

## About

This was my submission as the final project in the [Ruby on Rails course](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-on-rails) over at The Odin Project. It encompasses a ton of what I've come to know about Rails through my learning there, and I'll discuss its feature set below. So grab a hot cup and enjoy :coffee:

## Getting Started / How to Use

For running this app locally, I recommend having the following prerequisites:

```
Ruby >= 3.1.2
Rails >= 7.0.2
Bundler >= 2.2.32
PosgreSQL >= 12.12
libvips # for ActiveStorage
```

After verifying you have the prereqs, you can clone this repo, `cd` into the project's root directory, and run the setup script with `bin/setup`. This will setup the database, install dependencies, and setup JS and CSS bundling

After the setup script runs, you can run `bin/dev` to start the dev server. By default the site will be served at `http://localhost:3000`. Note that if you want to use GitHub OAuth, you will have to go through some extra steps shown below, but everything else should work fine out of the box.

### Using OAuth Locally

In order to run the app with OAuth locally, you'll need to go through a few extra steps.

1. Create an OAuth app on GitHub and take note of your Client ID and Secret.
2. The homepage will be `http://localhost:3000` and the callback URL will be `http://localhost:3000/users/auth/github/callback`.
3. Allow the rails app access to the OAuth API keys through ENV variables. I used the [figaro gem](https://github.com/laserlemon/figaro) for this, and it's already listed as a dev dependency in the Gemfile if you want to use it as well.

And you should be good to go!

## Features

This is a mock social network app and has many of the core features associated with social networking:

-  **User Accounts and Authentication**  
   Users can create an account in two ways: through a traditional sign up form or through using OmniAuth with GitHub. Auth is managed with the [Devise gem](https://github.com/heartcombo/devise). After signing up, users are given a Profile featuring some basic biographical information they can edit. Users can also edit their sign-in information provided they created a traditional account and not an OAuth one
-  **CRUD Resources**  
   Users can write posts, users can comment on posts, and users can "like" both posts and comments. The `Like` model is polymorphically associated with either a post or a comment. Users can delete all of these resources, and they can freely edit their own posts and comments.
-  **Friending**  
   Users can send friend requests to other users. If the other user accepts the friend request, then the users are "friends". They will show up in each others' friends list, and their posts will appear in others timelines. Users can reject friend requests, withdraw friend requests that they've sent, and remove users from their friends list.
-  **Notifications**  
   There is a notification system built with Rails's "concern" module to provide similar functionality across different models. Users are notified when someone comments on one of their posts, when someone likes one of their posts or comments, and when someone sends a friend request to or accepts a friend request from the user.
-  **Responsive Styles**  
   This app was styled using the Tailwind CSS framework. I used mobile-first design principles to develop styles that maintain visual cohesion across different viewport sizes.
-  **Robust Test Suite**  
   This project includes over 100 test cases with 97% coverage (measured using (SimpleCov)[https://github.com/simplecov-ruby/simplecov]). Model methods, decorators, and helpers are unit tested with RSpec, and every major feature of the site is system tested using RSpec and Capybara.

## Reflections

## Improvements

## Special Thanks
