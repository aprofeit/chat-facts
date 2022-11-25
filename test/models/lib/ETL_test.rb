require 'test_helper'

class ETLTest < ActiveSupport::TestCase
  test 'importing users' do
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

  test 'users exist after import' do
    ETL.new.import_users

    assert User.find_by(name: 'Alexander Profeit')
  end
end
