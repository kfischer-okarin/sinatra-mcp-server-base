# frozen_string_literal: true
require "minitest"
require "rest-client"

raise "TEST_SERVER_URL environment variable is not set" unless ENV['TEST_SERVER_URL']

puts "Running acceptance tests against server at #{ENV['TEST_SERVER_URL']}"
puts

module AcceptanceTestDSL
  def before_setup
    @resource = RestClient::Resource.new(ENV['TEST_SERVER_URL'])
  end
end

Minitest::Spec.include AcceptanceTestDSL
