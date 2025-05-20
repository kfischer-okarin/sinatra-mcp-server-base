# frozen_string_literal: true

require "open3"
require "pathname"
require "timeout"

# LocalAcceptanceTestServer starts a local production instance of the application.
# It is used as target for acceptance tests.
class LocalAcceptanceTestServer
  attr_reader :url

  def initialize(port)
    @command = "RACK_ENV=production PORT=#{port} bundle exec puma -C config/puma.rb"
    @url = "http://localhost:#{port}"
    @wait_thread = nil
  end

  # Starts the server and waits for it to be ready.
  def start
    Dir.chdir(app_root_directory) do
      puts "Starting server: #{@command}..."
      _, server_stdout, @wait_thread = Open3.popen2e(@command)
      puts "Server started with PID #{@wait_thread.pid}"

      begin
        wait_for_io_line_matching(server_stdout, /Use Ctrl-C to stop/, timeout: 10)
      rescue Timeout::Error
        raise "Server did not start within the expected time"
      end
    end
  end

  # Stops the server if it is running.
  def stop
    return unless @wait_thread&.alive?

    begin
      puts "Stopping server..."
      Process.kill("INT", @wait_thread.pid)
      @wait_thread.join
    rescue Exception => e
      puts "Failed to stop server: #{e.message}"
    end
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
      raise "Server output ended unexpectedly"
    end
  end
end
