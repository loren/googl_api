source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '>= 5.0.0.racecar1', '< 5.1'
gem 'puma', '~> 3.0'
gem 'googl'

group :development do
  gem 'listen'
  gem 'binding_of_caller'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'better_errors'
end

group :development, :test do
  gem "rspec-rails", "3.5.0.beta3"
end

group :test do
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'webmock'
  gem 'vcr'
  gem 'codeclimate-test-reporter', require: false
end