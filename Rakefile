# Rakefile for Sinatra MCP Server Base
require "bundler"
require "rake"
require "standard/rake"

require_relative "lib/local_acceptance_test_server"

desc "Run the development server"
task :dev do
  sh "./scripts/start-server.sh"
end

desc "Run acceptance tests against a specified server URL"
task :acceptance_tests, [:server_url] do |t, args|
  raise "server_url argument is required" unless args[:server_url]

  acceptance_tests_dir = File.expand_path("acceptance-tests", __dir__)
  Bundler.with_unbundled_env do
    Dir.chdir(acceptance_tests_dir) do
      system({"TEST_SERVER_URL" => args[:server_url]}, "bundle exec ruby run_all_tests.rb")
    end
  end
end

desc "Run local acceptance tests against production-mode server (optionally specify port)"
namespace :acceptance_tests do
  task :local, [:port] do |t, args|
    port = (args[:port] || 9292).to_i
    server = LocalAcceptanceTestServer.new(port)
    server.start
    begin
      Rake::Task[:acceptance_tests].invoke(server.url)
    ensure
      server.stop
    end
  end
end
