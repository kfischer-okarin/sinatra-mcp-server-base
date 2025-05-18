# frozen_string_literal: true

require "sinatra"
require "model_context_protocol"

require_relative "lib/mcp_exception_reporter"
SERVER_NAME = "my_server"

ModelContextProtocol.configure do |config|
  config.exception_reporter = MCPExceptionReporter.instance
end

post "/mcp" do
  content_type :json

  MCPExceptionReporter.instance.sinatra_logger = request.logger

  server = ModelContextProtocol::Server.new(
    name: SERVER_NAME
  )
  server.handle_json(request.body.read)
end
