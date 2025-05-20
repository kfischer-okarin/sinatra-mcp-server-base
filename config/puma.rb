# frozen_string_literal: true

env = ENV.fetch("RACK_ENV", "development")
environment env

port ENV.fetch("PORT", 3000)

case env
when "production"
  # Sensible defaults for single Heroku Basic Dyno
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#cedar-generation-apps
  default_max_threads = 5
  default_workers = 1
  silence_single_worker_warning
when "development"
  default_max_threads = 1
  default_workers = 0
end

threads_count = ENV.fetch("PUMA_MAX_THREADS", default_max_threads).to_i
threads threads_count, threads_count

workers_count = ENV.fetch("WEB_CONCURRENCY", default_workers).to_i
workers workers_count
