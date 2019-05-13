# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Use real threads
ruby '2.5.3', engine: 'jruby', engine_version: '9.2.7.0'

group :development, :test do
  gem 'pry', '~> 0.12'
  gem 'rubocop', '~> 0.68'
  gem 'rubocop-performance', '~> 1.2'
end

gem 'concurrent-ruby', '~> 1.1'
gem 'faraday', '~> 0.15'
gem 'faraday_middleware', '~> 0.13'
gem 'holidays', '~> 7.1'
gem 'httparty', '~> 0.17'
gem 'semantic_logger', '~> 4.5'
gem 'tty-prompt', '~> 0.18'
