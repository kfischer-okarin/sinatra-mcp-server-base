# frozen_string_literal: true

require_relative "../test_helper"

describe "Echo tool" do
  it "should echo the message" do
    results = call_tool("echo", {message: "Hello, MCP!"})

    value(results.length).must_equal 1, "Expected one result"
    value(results[0]).must_equal({type: "text", text: "Echo: Hello, MCP!"})
  end
end
