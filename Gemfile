source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'mysql2'

gem 'capistrano', '2.13.5'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.2'
gem 'exifr'
gem 'jquery-rails'
gem 'mini_magick'
gem "paperclip", "~> 5.0.0.beta1"
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
  gem 'rspec-rails'
end