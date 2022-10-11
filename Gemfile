source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise", "~> 4.8"
gem "figaro"
gem "image_processing", "~> 1.2"
gem "inline_svg"
gem "jbuilder"
gem "jsbundling-rails"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "ruby-vips"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "capybara"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "rubocop"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov", require: false
  gem "webdrivers"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "annotate"
  gem "bullet"
  gem "letter_opener"
  gem "web-console"
end
