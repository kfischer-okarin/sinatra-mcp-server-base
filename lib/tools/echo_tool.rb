Tools.define(
  name: "echo",
  description: "A simple tool that echoes back the input message",
  input_schema: {
    properties: {
      message: {type: "string", description: "The message to echo back"}
    },
    required: ["message"]
  }
) do |message:|
  ModelContextProtocol::Tool::Response.new([{type: "text", text: "Echo: #{message}"}])
end
