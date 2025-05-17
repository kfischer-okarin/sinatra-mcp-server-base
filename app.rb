# frozen_string_literal: true
require "sinatra"
require "model_context_protocol"

post "/mcp" do
  server = ModelContextProtocol::Server.new(
    name: "my_server"
  )
  server.handle_json(request.body.read)
end
