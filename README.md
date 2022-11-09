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
Yarn >= 1.22
PosgreSQL >= 14.5
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

#### User Accounts and Authentication
Users can create an account in two ways: through a traditional sign up form or through using OmniAuth with GitHub. Auth is managed with the [Devise gem](https://github.com/heartcombo/devise). After signing up, users are given a Profile featuring some basic biographical information they can edit. Users can also edit their sign-in information provided they created a traditional account and not an OAuth one

#### CRUD Resources
Users can write posts, users can comment on posts, and users can "like" both posts and comments. The `Like` model is polymorphically associated with either a post or a comment. Users can delete all of these resources, and they can freely edit their own posts and comments.

#### Friending
Users can send friend requests to other users. If the other user accepts the friend request, then the users are "friends". They will show up in each others' friends list, and their posts will appear in each others' timelines. Users can reject friend requests, withdraw friend requests that they've sent, and remove users from their friends list.

#### Notifications
There is a notification system built with Rails's "concern" module to provide similar functionality across different models. Users are notified when someone comments on one of their posts, when someone likes one of their posts or comments, and when someone sends a friend request to or accepts a friend request from the user.

#### Image Uploads
Users can upload an avatar image. A gravatar associated with the user's email is used for the avatar if the user hasn't uploaded one. Users also have the option to attach an image to their posts. Image uploads are implemented using rails' ActiveStorage, and in production, Amazon's S3 Service is used for storage.

#### Responsive Styles
This app was styled using the Tailwind CSS framework. I used mobile-first design principles to develop styles that maintain visual cohesion across different viewport sizes.

#### Modern Rails Frontend
The frontend of the app does use server rendered templates, but I also make use of Turbo and Stimulus to provide a more modern, SPA-like feel to various sections of the site. When a user likes a post or comment, a full page reload isn't triggered thanks to Turbo Streams. I also use Stimulus to provide some JavaScript reactivity with dropdowns, toggles, and form feedback.

#### Robust Test Suite
This project has 97% test coverage (measured using [SimpleCov](https://github.com/simplecov-ruby/simplecov)). Model methods, decorators, and helpers are unit tested with RSpec, and every major feature of the site is system tested using RSpec and Capybara. I also use [FactoryBot](https://github.com/thoughtbot/factory_bot_rails) to aid in creating data for my tests.

## Reflections

I was able to explore a lot of fun and interesting problems while developing this project.

#### Deployment

My previous projects were deployed to Heroku, but with the free tier going away, I figured I'd give another method a try. This project is deployed to a DigitalOcean droplet that's running [dokku](https://github.com/dokku/dokku). This was a great experience and also required a lot more hands-on setup than working with Heroku did. I was able to learn a lot about configuring my own production environment and server.

#### Querying Efficiently

Relative to my previous Rails projects, I put much more thought into the efficiency of my database queries. I used the [bullet gem](https://github.com/flyerhzm/bullet) to help spot dreaded N+1 queries, and I also used counter caches to avoid having to execute COUNT queries in places where a count needs to be frequently read (ie. posts' like and comment count).

#### Working with ActiveStorage

ActiveStorage is a Rails module that helps manage file uploads and storage. My project allows users to upload pictures for their avatar or just to attach to any post. One of the challenges for working with ActiveStorage is that it doesn't have any out of the box validations. This meant that I had to write my own custom validators for validating the MIME type and the size of the images my users upload.

Additionally the default widget HTML gives you on a file input field isn't great. I combined CSS and a couple of Stimulus controllers to get something that fits the design of the site better and allows users to see a small preview of the image they're about to submit.

#### Unique Friendships

Modeling "friendship" was a challenge for me in the project. A Friendship holds two foreign keys to a user: the person who initiated the Friendship and the person who accepted it. This needs to be reciprocal such that if I'm your friend, you're my friend as well. Getting the queries and associations properly going for this was a challenge. One problem in particular that took me some research: how do you make each "friendship" pairing unique? I should only be able to have one "Friendship" pairing with any other user, regardless of who initiated or accepted the Friendship. I could've written a custom validator to handle it, but it's nice to implement these things on the database level to avoid race conditions and ensure integrity of the data. It's not too difficult to find solutions like the following:

```rb
# in model
validates user_id:, uniqueness: { scope: :friend_id }

# in schema
t.index ["user_id", "friend_id"], unique: true
```
But this kind of thing has a big problem: it doesn't verify the _inverse_ relationship. So `Friendship.new(user: u1, friend: u2)` and `Friendship.new(user: u2, friend: u1)` are allowed to coexist. Eventually I learned about indexing on an expression, which allowed me to get the constraint I want and is also pretty dang clean:

```rb
# db/migrations/

def change
  add_index :friendships,
            'least(sender_id, receiver_id), greatest(sender_id, receiver_id)',
            unique: true
end
```
This will create a unique index over the pair of foreign keys where the lower id is positioned first and the greater one second, so it verifies uniqueness on any ordering of the users. Pretty cool!

## Improvements

I'm pretty happy with how this one turned out, and I learned a ton. There are always improvements that could be made though. Here's a list of some I might implement down the line:

- Rails has a module called [ActionText](https://guides.rubyonrails.org/action_text_overview.html) that I could use to give my users a rich, WYSIWYG editor for their posts and comments.
- I could definitely get more mileage out of Turbo and Turbo-Streams. Currently the only place I leverage Turbo-Streams is for allowing users to like and unlike posts without a full page refresh. I could push this much further with streams for creating, removing, and editing posts and comments.
- I could wire up my notifications system with ActionCable (Rails's interface for working with websockets) so that users could be alerted in real-time to friend requests and comments on their posts, etc. This was a bit of a low priority for me in dev because it's a feature users are unlikely to be able to see it in action, but I think it'd still be fun to implement down the line.

## Special Thanks

