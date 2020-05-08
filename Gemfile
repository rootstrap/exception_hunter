source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in exception_hunter.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'pagy', '~> 3.8'
# https://github.com/rspec/rspec-rails/issues/2177
gem 'rspec-core', git: 'https://github.com/rspec/rspec-core'
gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations'
gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks'
gem 'rspec-support', git: 'https://github.com/rspec/rspec-support'

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'devise', '~> 4.7'
end

group :test do
  gem 'rspec-rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 4.3'
end
