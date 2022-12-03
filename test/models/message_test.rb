require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test 'there should be 72 reacdted messages' do
    assert_equal 72, messages.filter { |m| m['reactions'] }.size
  end

  private

  def messages
    @message ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))['messages']
  end
end
