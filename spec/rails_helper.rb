ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start "rails" do
  add_group "Classes", ["app/classes"]
end

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require "paperclip/matchers"

ActiveRecord::Migration.maintain_test_schema!

Dir["#{Rails.root}/spec/controllers/concerns/*.rb"].sort.each { |f| require f}
Dir["#{Rails.root}/spec/models/concerns/*.rb"].sort.each { |f| require f}
Dir["#{Rails.root}/spec/support/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers

  config.before(:suite) do
    Warden.test_mode!
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
