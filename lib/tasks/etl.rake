namespace :etl do
  desc 'Destroy all models'
  task implode: :environment do
    User.delete_all
    Message.delete_all
  end

  desc 'Extract and create database models for each unique user'
  task users: [:environment] do
    ETL.new.import_users
  end

  task messages: :environment do
    ETL.new.import_messages
  end
end
