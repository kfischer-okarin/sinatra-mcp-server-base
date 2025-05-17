# frozen_string_literal: true

require_relative "../test_helper"

describe "Initialization" do
  it "should return a valid response from the MCP endpoint" do
    response = send_mcp_request(
      method: "initialize",
      params: {
        protocolVersion: "2024-11-05",
        capabilities: {},
        clientInfo: {
          name: "TestClient",
          version: "1.0.0"
        }
      }
    )

    value(response[:result]).must_include(:capabilities, :serverInfo)
    value(response[:result]).must_be_hash_with_values(protocolVersion: "2024-11-05")
  end
end
