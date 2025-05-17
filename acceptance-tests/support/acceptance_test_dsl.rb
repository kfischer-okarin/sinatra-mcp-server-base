# frozen_string_literal: true
require "json"

require "minitest"
require "rest-client"

raise "TEST_SERVER_URL environment variable is not set" unless ENV['TEST_SERVER_URL']

puts "Running acceptance tests against server at #{ENV['TEST_SERVER_URL']}"
puts

module AcceptanceTestDSL
  def before_setup
    @resource = RestClient::Resource.new(ENV['TEST_SERVER_URL'])
    @next_id = 1
  end

  def send_mcp_request(method:, params: {})
    json_rpc_request = {
      jsonrpc: "2.0",
      id: @next_id,
      method:,
      params:
    }
    @next_id += 1

    response = @resource['/mcp'].post(json_rpc_request.to_json, content_type: :json)
    response_body = JSON.parse(response.body, symbolize_names: true)

    raise "Invalid JSON-RPC response: #{response_body}" unless Helpers.valid_json_rpc_response?(response_body)
    raise "Unexpected Response ID: #{response_body[:id]}" unless response_body[:id] == json_rpc_request[:id]

    response_body
  rescue RestClient::ExceptionWithResponse => e
    raise "MCP request failed: #{e.response}"
  end

  module Helpers
    module_function

    def valid_json_rpc_response?(response_body)
      response_body.is_a?(Hash) &&
      response_body[:jsonrpc] == "2.0" &&
      response_body.key?(:id) &&
      (response_body.key?(:result) || response_body.key?(:error))
    end
  end
end

Minitest::Spec.include AcceptanceTestDSL
