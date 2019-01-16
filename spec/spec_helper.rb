require "benchmark"
require "bundler/setup"
require "capybara/jsdom"
require "test_app"
require "capybara/rspec"

# Capybara.default_driver = :rack_test
Capybara.default_driver = :jsdom
# Capybara.default_driver = :selenium
Capybara.app = Sinatra::Application
Capybara.server = :webrick

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def time
  start = Time.now

  yield

  puts "Took: #{Time.now - start}s"
end
