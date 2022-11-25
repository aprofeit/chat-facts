require "test_helper"

class UserTest < ActiveSupport::TestCase
  attr_reader :etl

  setup do
    @etl ||= ETL.new
  end

  test 'creating a user' do
    assert User.create!(valid_user_params)
  end

  test 'can calculate the amount of reactions a user has done' do
    etl.import_users
    etl.import_messages
    etl.import_reactions

    user = User.find_by!(name: 'Dorina Rusu')
    assert_equal 497, user.reactions.count
  end

  test 'can calculate the amount of messages a user has sent' do
    etl.import_users
    etl.import_messages
    etl.import_reactions
    
    user = User.find_by!(name: 'Alexander Profeit')
    assert_equal 254, user.messages.count
  end

  private

  def valid_user_params
    {
      name: 'Trogdor',
    }
  end

  def messages
    @message ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
