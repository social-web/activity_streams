# frozen_string_literal: true

# Measure test coverage
require 'simplecov'
SimpleCov.start

require "activity_streams"

RSpec.configure do |config|
  config.before(:all) { ActivityStreams.config.domain = 'example.org' }

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = "tmp/.rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
