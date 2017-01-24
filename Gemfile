source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'mysql2'

gem 'aws-sdk', '~> 2.7.0'
gem 'capistrano', '2.13.5'
gem 'codemirror-rails'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-validation-rails'
gem 'paperclip', '~> 5.0.0'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'

group :development do
  gem 'puma', '~> 3.0'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'simplecov', require: false
end