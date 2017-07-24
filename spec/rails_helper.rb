ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start "rails" do
  add_group "Classes", ["app/classes"]
  add_group "Paperclip", ["lib/paperclip"]
  add_group "Policies", ["app/policies"]
end

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'paperclip/matchers'
require "#{Rails.root}/spec/support/controller_macros.rb"
require 'pundit/rspec'
require 'sucker_punch/testing/inline'

ActiveRecord::Migration.maintain_test_schema!

Dir["#{Rails.root}/spec/controllers/concerns/*.rb"].sort.each { |f| require f}
Dir["#{Rails.root}/spec/models/concerns/*.rb"].sort.each { |f| require f}
Dir["#{Rails.root}/spec/support/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers

  config.add_setting :redirect_html, default: "<html><body>You are being <a href=\"http://test.host/users/sign_in\">redirected</a>.</body></html>"
  config.add_setting :user_roles,    default: [:user, :admin, :vetter, :local_president]
  config.add_setting :non_admins,    default: [:user, :vetter, :local_president]
  config.add_setting :http_referer,  default: "http://toolkit.afscme.org"

  config.before(:suite) do
    Warden.test_mode!
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start

    allow(DocumentPdfJob).to receive(:perform_async).and_return(true)
    allow(DocumentThumbnailJob).to receive(:perform_async).and_return(true)

    # Only do this in controller specs. Only controller and helper specs define request.
    # However, helper specs will set request to nil.
    if defined?(request) && !request.nil?
      request.env['HTTP_REFERER'] = config.http_referer
    end
  end

  # Clean up all jobs specs with truncation
  config.before(:each, type: :job) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
