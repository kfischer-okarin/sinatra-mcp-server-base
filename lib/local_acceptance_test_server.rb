# frozen_string_literal: true
require "open3"
require "pathname"
require "timeout"

# LocalAcceptanceTestServer handles starting and stopping a local Sinatra server in production mode
# which can be used as target for running acceptance tests against it.
class LocalAcceptanceTestServer
  attr_reader :url

  def initialize(port)
    @command = "RACK_ENV=production bundle exec rackup -p #{port}"
    @url = "http://localhost:#{port}"
    @wait_thread = nil
  end

  def start
    Dir.chdir(app_root_directory) do
      puts "Starting server: #{@command}..."
      _, server_stdout, @wait_thread = Open3.popen2e(@command)

      begin
        wait_for_io_line_matching(server_stdout, /^\* Listening on/, timeout: 10)
      rescue Timeout::Error
        raise "Server did not start within the expected time"
      end
    end
  end

  def stop
    return unless @wait_thread&.alive?

    Process.kill('TERM', @wait_thread.pid) rescue nil
  end

  private

  def app_root_directory
    Pathname.new(__dir__).join("..")
  end

  def wait_for_io_line_matching(io, regex, timeout: 10)
    Timeout.timeout(timeout) do
      while (line = io.gets)
        return if line.match?(regex)
      end
      # If we reach here, it means the output ended without matching the regex
      raise "Output ended unexpectedly"
    end
  end
end
