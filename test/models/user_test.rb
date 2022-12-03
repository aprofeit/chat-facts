require "test_helper"

class UserTest < ActiveSupport::TestCase
  attr_reader :etl

  setup do
    @etl ||= ETL.new
  end

  test 'creating a user' do
    assert User.create!(valid_user_params)
  end

  test 'imports the expected amount of reactions' do
    etl.import_users
    etl.import_messages

    user = User.find_by!(name: 'Dorina Rusu')
    expected_reaction_count = test_messages['messages']
      .filter { |m| m['sender_name'] == 'Dorina Rusu' }
      .filter { |m| m['reactions'] }
      .flat_map { |m| m['reactions'] }.size

    assert_difference -> { user.reactions.count }, expected_reaction_count do
      etl.import_reactions
    end
  end

  test 'can calculate the amount of messages a user has sent' do
    etl.reset_import
    
    user = User.find_by!(name: 'Alexander Profeit')

    expected_message_count = test_messages['messages']
      .filter { |m| m['sender_name'] == 'Alexander Profeit' }
      .size

    assert_equal expected_message_count, user.messages.count
  end

  test 'users can return their reactions' do
    user = users(:batcat)

    assert_equal 1, user.reactions.count
  end

  test 'users have the expected amount of received reactions' do
    etl.reset_import

    user = User.find_by!(name: 'Justin Turple')

    assert_equal 8, user.reactions.count
  end

  test 'users have the expected amount of sent reactions' do
  end

  private

  def valid_user_params
    {
      name: 'Trogdor'
    }
  end

  def test_messages
    @test_messages ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
