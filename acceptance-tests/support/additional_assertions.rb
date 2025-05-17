# frozen_string_literal: true

module AdditionalAssertions
  def assert_hash_with_values(expected, actual, msg = nil)
    assert_instance_of Hash, actual, msg
    expected.each do |key, value|
      assert actual.key?(key), message(msg) { "Expected key '#{key}' to be present in #{mu_pp actual}" }
      assert_equal value, actual[key], message(msg) { "Expected value for key '#{key}' to be #{value}, but got #{actual[key]}" }
    end
  end
end

Minitest::Assertions.include(AdditionalAssertions)
Minitest::Expectations.infect_an_assertion :assert_hash_with_values, :must_be_hash_with_values
