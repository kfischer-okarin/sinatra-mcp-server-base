# frozen_string_literal: true

source "https://rubygems.org"

# Web Framework
gem "sinatra", "~> 4.1"
# MCP Server library
# Official Ruby SDK but no official release yet so use git commit
gem "model_context_protocol", git: "https://github.com/modelcontextprotocol/ruby-sdk.git", ref: "784b8b85481098c15887189ed8e8cfb4c5a67852"

group :development, :test do
  # Web server
  gem "puma", "~> 6.6"
  # Rack application runner
  gem "rackup", "~> 2.2"
end
