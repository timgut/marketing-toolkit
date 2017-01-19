require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

# Call binding.irb to enter REPL session
if Rails.env.development? || Rails.env.test?
  require 'irb'
end

module AfscmeToolkit
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
