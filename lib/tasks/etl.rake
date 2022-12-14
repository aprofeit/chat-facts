require 'rails/all'
require './app/lib/ETL'

namespace :etl do
  def etl
    @etl ||= ETL.new
  end

  desc 'Read and create models for each user'
  task users: [:environment] do
    etl.import_users
  end

  desc 'Read and create models for each message'
  task messages: [:environment, :users] do
    etl.import_messages
  end

  desc 'Read and create models for each reaction'
  task reactions: [:environment, :messages] do
    etl.import_reactions
  end

  desc 'Delete existing models'
  task destroy_all: :environment do
    etl.delete_all
  end

  desc 'Reset with current message files'
  task initialize: [:environment] do
    etl.delete_all
    etl.import
  end

  desc 'Import from db/files/messages' do
  task import: :environment
    etl.import
  end
end
