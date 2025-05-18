# frozen_string_literal: true

require "singleton"

# MCPExceptionReporter handles exception logging for the MCP Server
# It uses the Sinatra logger if available.
class MCPExceptionReporter
  include Singleton

  attr_accessor :sinatra_logger

  def call(exception, server_context)
    original_error = exception.original_error
    message = "Exception occured during MCP message handling: #{exception_details(original_error)} (Server context: #{server_context.inspect})"

    if sinatra_logger
      sinatra_logger.error message
    else
      puts message
    end
  end

  private

  def exception_details(exception)
    if exception.backtrace
      "#{exception.inspect} at #{exception.backtrace.first}"
    else
      exception.inspect
    end
  end
end
