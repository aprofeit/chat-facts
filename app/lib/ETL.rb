class ETL
  def import_users
    messages['participants'].flat_map(&:values).each do |name|
      User.create!(name: name)
    end
  end

  private

  def messages
    @message ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
