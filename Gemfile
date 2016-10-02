ruby File.read('.ruby-version').strip

source 'https://rubygems.org'

gem 'capistrano', '~> 3.1'
gem 'capistrano-passenger'
gem 'capistrano-rails', '~> 1.1'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
end
