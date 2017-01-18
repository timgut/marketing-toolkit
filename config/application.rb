require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module AfscmeToolkit
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
