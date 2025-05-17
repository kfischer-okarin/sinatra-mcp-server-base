# Rakefile for Sinatra MCP Server Base
require "bundler"
require 'rake'

require_relative './lib/local_acceptance_test_server'

desc 'Run local acceptance tests against production-mode server'
task :acceptance_tests_local do
  server = LocalAcceptanceTestServer.new(9292)
  server.start

  acceptance_tests_dir = File.expand_path('acceptance-tests', __dir__)
  Bundler.with_unbundled_env do
    begin
      Dir.chdir(acceptance_tests_dir) do
        system({ 'TEST_SERVER_URL' => server.url }, 'bundle exec ruby run_all_tests.rb')
      end
    ensure
      server.stop
    end
  end
end

desc 'Run the development server with rackup'
task :dev do
  sh 'bundle exec rackup'
end
