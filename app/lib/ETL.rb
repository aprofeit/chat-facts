class ETL
  def import_users
    participants = messages['participants'].flat_map(&:values)
    user_params = participants.map do |name|
      { name: name }
    end

    User.create!(user_params)
  end

  def destroy_all
    User.destroy_all
  end

  def import_messages
    messages['messages'].map do |message|
      m = Message.new(
        user: User.find_by!(name: message['sender_name']),
        sent_at: Time.at(message['timestamp_ms'] / 1000),
        content: message['content'],
        kind: message['type'],
        is_unsent: message['is_unsent'],
        is_taken_down: message['is_taken_down'],
        bumped_message_metadata: message['bumped_message_metadata'],
      )

      if message['reactions']
        m.reactions = message['reactions'].map { |r| Reaction.new(content: r['reaction'], user: User.find_by!(name: r['actor'])) }
      end

      m
    end.each(&:save)
  end

  def import_reactions
    Message.includes(:reactions).where.not(reactions: nil).find_each do |message|
      message.reactions.where.not(content: nil).create!(content: message['reactions'], user: message.user)
    end
  end

  def destroy_all
    User.delete_all
    Message.delete_all
    Reaction.delete_all
  end

  def import
    import_users
    import_messages
    import_reactions
  end

  private

  def messages
    @message ||= JSON.load_file(Rails.root.join('test', 'fixtures', 'files', 'messages.json'))
  end
end
