Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.paperclip_defaults = {
    path: ':dynamic_path'
  }

  config.action_mailer.smtp_settings = {
    address:              "smtp.mandrillapp.com",
    port:                 587,                                 # port 2525 is also supported with STARTTLS
    enable_starttls_auto: true,                                # detects and uses STARTTLS
    user_name:            "mandrill@trilogyinteractive.com",
    password:             "OPreGdAKhDL5fyUPp8M9cw",            # SMTP password is any valid API key
    authentication:       "plain",                             # Mandrill supports 'plain' or 'login'
    domain:               "toolkit-app.afscme.bytrilogy.com'", # your domain to identify your server when connecting
  }

  config.action_mailer.default_url_options = { :host => 'afscme-toolkit.bytrilogy.com' }
  
  config.require_master_key = false
end
