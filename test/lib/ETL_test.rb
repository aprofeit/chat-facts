require 'test_helper'

class ETLTest < ActiveSupport::TestCase
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
      ETL.new.import_users
    end

    assert_equal expected_users.sort, User.find_each.map(&:name).sort
  end

  test 'importing messages imports the correct amount of messages' do
    assert_difference 'Message.count', 1895 do
      ETL.new.import_messages
    end
  end

  test 'users exist after import' do
    ETL.new.import_users

    assert User.find_by(name: 'Alexander Profeit')
  end

  test 'reset deletes all associated models' do
    assert_difference 'User.count', User.count * -1 do
      ETL.new.reset
    end
  end
end
