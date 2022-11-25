namespace :etl do
  desc 'Extract and create database models for each unique user'
  task users: :environment do
    ETL.new.import_users
  end

  task reset: :environment do
    User.delete_all
  end
end
