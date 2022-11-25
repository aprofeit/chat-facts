require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'creating a user' do
    assert User.create!(valid_user_params)
  end

  private

  def valid_user_params
    {
      name: 'Trogdor',
    }
  end
end
