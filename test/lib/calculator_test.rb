require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  attr_reader :messages

  setup do
    @messages = JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end

  test 'Alexander has the expected amount of messages' do
    actual_message_count = @messages['messages'].filter { |m| m['sender_name'] == 'Alexander Profeit' }.size

    assert_equal 59, actual_message_count
  end
end
