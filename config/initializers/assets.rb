# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << "#{Rails.root}/app/assets/videos"
Rails.application.config.assets.paths << "#{Rails.root}/app/assets/fonts"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/javascripts"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets"

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  highlight-js-railscasts.css 
  highlight.pack.js 
  jquery.tablednd.1.0.3.min.js
  reset.css
  login.css
  styles.css
  login.css
  type.css
  global.css
)
