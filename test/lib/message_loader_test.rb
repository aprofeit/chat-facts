require 'test_helper'

class MessageLoaderTest < ActiveSupport::TestCase
  test 'message loader should read all the participants from all the files' do assert_equal 3, MessageLoader.new.participants.sort.size
  end
end
