class ETL
  def import_users
    messages['participants'].flat_map(&:values).each do |name|
      User.create!(name: name)
    end
  end

  def implode
    User.destroy_all
  end

  def import_messages
    messages['messages'].each do |message|
      Message.create!(
        user: User.find_by!(name: message['sender_name']),
        sent_at: Time.at(message['timestamp_ms'] / 1000),
        content: message['content'],
        kind: message['type'],
        is_unsent: message['is_unsent'],
        is_taken_down: message['is_taken_down'],
        bumped_message_metadata: message['bumped_message_metadata'],
      )
    end
  end

  def import_reactions
    Message.find_each do |message|
      next unless message.reactions

      message.reactions.create!(content: message['reactions'], user: message.user)
    end
  end

  private

  def messages
    @message ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
