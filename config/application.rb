require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

# Call binding.irb to enter REPL session
if Rails.env.development? || Rails.env.test?
  require 'irb'
end

require 'csv'

module AfscmeToolkit
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.active_job.queue_adapter = :sucker_punch

    # Uncomment to see backtraces of ActiveRecord queries
    # ActiveRecordQueryTrace.enabled = true
  end
end

require 'afscme_toolkit'
