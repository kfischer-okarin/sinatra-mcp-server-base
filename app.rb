# frozen_string_literal: true

require "sinatra"
require "model_context_protocol"

SERVER_NAME = "my_server"

post "/mcp" do
  content_type :json

  server = ModelContextProtocol::Server.new(
    name: SERVER_NAME
  )
  server.handle_json(request.body.read)
end
