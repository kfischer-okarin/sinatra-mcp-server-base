# frozen_string_literal: true

require "json"

require "minitest"
require "rest-client"

raise "TEST_SERVER_URL environment variable is not set" unless ENV["TEST_SERVER_URL"]

puts "Running acceptance tests against server at #{ENV["TEST_SERVER_URL"]}"
puts

module AcceptanceTestDSL
  def before_setup
    @resource = RestClient::Resource.new(ENV["TEST_SERVER_URL"])
    @next_id = 1
  end

  def call_tool(name, arguments = {})
    response = send_mcp_request(method: "tools/call", params: {name:, arguments:})

    result = response[:result]
    assert_hash_with_values({isError: false}, result, "Expected tool call to succeed")
    assert_includes(result, :content, "Expected tool call response to include 'contents'")

    result[:content]
  end

  def send_mcp_request(method:, params: {})
    json_rpc_request = {
      jsonrpc: "2.0",
      id: @next_id,
      method:,
      params:
    }
    @next_id += 1

    response = @resource["/mcp"].post(json_rpc_request.to_json, content_type: :json)

    assert_hash_with_values({content_type: "application/json"}, response.headers, "Expected response to have JSON content type")
    response_body = JSON.parse(response.body, symbolize_names: true)

    assert_hash_with_values({jsonrpc: "2.0"}, response_body, "Invalid JSON-RPC response format")
    assert_includes(response_body, :id, "Invalid JSON-RPC response: missing 'id'")
    assert response_body.key?(:result) || response_body.key?(:error), "Invalid JSON-RPC response: missing 'result' or 'error'"
    assert_equal response_body[:id], json_rpc_request[:id], "Response ID does not match request ID"

    response_body
  rescue RestClient::ExceptionWithResponse => e
    raise "MCP request failed: #{e.response}"
  end
end

Minitest::Spec.include AcceptanceTestDSL
