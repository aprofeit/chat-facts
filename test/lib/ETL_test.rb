require 'test_helper'

class ETLTest < ActiveSupport::TestCase
  attr_reader :etl

  setup do
    @etl = ETL.new
  end

  test 'importing users' do
    User.delete_all
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

  test 'implode deletes all associated models' do
    assert_difference 'User.count', User.count * -1 do
      etl.implode
    end
  end

  test 'importing messages imports the correct amount of messages' do
    etl.import_users

    assert_difference 'Message.count', 1895 do
      etl.import_messages
    end
  end

  test 'the first message is what would be expected' do
    etl.import_users
    etl.import_messages

    message = Message.first

    expected_content = "Quote by Joseph Stalin: â\u0080\u009CQuantity has a quality all its own.â\u0080\u009D"

    assert_equal expected_content, message.content
  end
end
