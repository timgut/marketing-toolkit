source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'rails', '5.2.1.1'
gem 'mysql2'

gem 'aws-sdk', '~> 2.7.0'
gem 'codemirror-rails'
gem 'coffee-rails', '~> 4.2'
gem 'croppie_rails'
gem 'devise', '~> 4.2'
gem 'dropzonejs-rails'
gem 'gretel'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-validation-rails'
gem 'kaminari'
gem 'mini_magick'
gem 'paperclip', '~> 5.0.0'
gem 'paperclip-meta'
gem 'papercrop'
gem 'pundit'
gem 'sass-rails', '~> 5.0'
gem 'sucker_punch', '~> 2.0'
gem 'therubyracer'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'wicked_pdf'
gem 'rufus-scheduler'

# moved outside of :development because of unknown error on remote migrations during deploy
gem 'listen', '~> 3.0.5'
gem 'tinymce-rails', github: "spohlenz/tinymce-rails", ref: "8a31db6"

group :development do
  gem 'puma', '~> 3.0'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.7.2', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'daemons'
  gem 'wkhtmltoimage-binary', '~> 0.12.4'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'simplecov', '0.13', require: false
end

group :development, :test do
  gem 'active_record_query_trace'
  gem 'byebug'
end
