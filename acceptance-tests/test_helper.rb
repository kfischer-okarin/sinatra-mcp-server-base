# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"

require_relative "support/acceptance_test_dsl"
require_relative "support/additional_assertions"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
