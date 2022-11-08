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

## Reflections

## Improvements

## Special Thanks
