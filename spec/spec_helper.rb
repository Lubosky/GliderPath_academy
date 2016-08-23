# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'sidekiq/testing'
require 'site_prism'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.

ActiveRecord::Migration.maintain_test_schema!

DEFAULT_HOST = 'lvh.me'
DEFAULT_PORT = 9887 + ENV['TEST_ENV_NUMBER'].to_i

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.fixture_path = '#{::Rails.root}/spec/fixtures'

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    Analytics.backend = FakeIntercom.new
  end

  # Keep RequestStore clean between specs
  config.before(:each) do
    RequestStore.clear!
  end

  config.before(:each) do |f|
    Sidekiq::Worker.clear_all

    if f.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif f.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif f.metadata[:sidekiq] == true
      Sidekiq::Testing.inline!
    elsif f.metadata[:type] == :feature
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end

  config.after(:suite) do
    Sidekiq::Worker.clear_all
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  Capybara.javascript_driver = :poltergeist
  Capybara.default_host = "http://#{DEFAULT_HOST}"
  Capybara.server_port = DEFAULT_PORT

  config.before :suite do
    Capybara.app_host = "http://#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end

  def get_file(filename)
    @get_file ||= File.open Rails.root.join('spec', 'support', 'images', filename)
  end

  config.include AnalyticsHelper
  config.include AbstractController::Translation
  config.include CheckoutHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers

end
