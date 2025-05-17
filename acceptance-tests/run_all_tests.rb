# frozen_string_literal: true

Dir.glob("features/*_test.rb", base: __dir__).each do |file|
  require_relative file
end
