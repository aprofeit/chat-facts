require 'test_helper'

class ETLTest < ActiveSupport::TestCase
  attr_reader :etl

  setup do
    @etl ||= ETL.new
  end

  test 'importing users' do
    etl.delete_all
    expected_users = ["Adam March",
                      "Alexander Profeit",
                      "Ashley Sexstone",
                      "Derek Pawsey",
                      "Dimitris Yannis Fotiadis",
                      "Dorina Rusu",
                      "Justin Turple",
                      "Kit MacKenzie",
                      "RenÃ©e Rachelle",
                      "Steph Melo"]

    assert_difference 'User.count', expected_users.size do
      etl.import_users
    end

    assert_equal expected_users.sort, User.find_each.map(&:name).sort
  end

  test 'users exist after import' do
    etl.import_users

    assert User.find_by(name: 'Alexander Profeit')
  end

  test 'destroy_all deletes all associated models' do
    assert_difference 'Message.count', Message.count * -1 do
      assert_difference 'Reaction.count', Reaction.count * -1 do
        assert_difference 'User.count', User.count * -1 do
          etl.delete_all
        end
      end
    end
  end

  test 'importing messages imports the correct amount of messages' do
    etl.import_users

    expected_message_count = test_messages['messages'].size

    assert_difference 'Message.count', expected_message_count do
      etl.import_messages
    end
  end

  test 'the first message is what would be expected' do
    etl.delete_all
    etl.import

    message = Message.first

    assert_equal 'Justin Turple', message.user.name
    assert_equal "Quote by Joseph Stalin: â\u0080\u009CQuantity has a quality all its own.â\u0080\u009D", message.content
  end

  test 'reactions should import by the expected number' do
    etl.import_users
    etl.import_messages
    user = User.find_by!(name: 'Dorina Rusu')
    expected_reaction_count = test_messages['messages']
      .filter { |m| m['sender_name'] == 'Dorina Rusu' }
      .filter { |m| m['reactions'] }
      .flat_map { |m| m['reactions'] }
      .size

    assert_difference -> { user.reactions.count }, expected_reaction_count do
      etl.import_reactions
    end
  end

  test 'import should import the expected number of models' do
    etl.delete_all

    expected_user_count = test_messages['participants'].size
    expected_message_count = test_messages['messages'].size
    expected_reaction_count = test_messages['messages']
      .filter { |m| m['reactions'] }
      .flat_map { |m| m['reactions'] }
      .size

    assert_difference 'User.count', expected_user_count do
      assert_difference 'Message.count', expected_message_count do
        assert_difference 'Reaction.count', expected_reaction_count do
          etl.import
        end
      end
    end
  end

  private

  def test_messages
    JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
