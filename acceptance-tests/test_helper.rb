# frozen_string_literal: true
require "minitest/autorun"
require "minitest/reporters"

require_relative "support/acceptance_test"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
