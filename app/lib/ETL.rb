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
        json_reactions: message['reactions']
      )

      m
    end.each(&:save)
  end

  def import_reactions
    Message.where.not(json_reactions: nil).find_each do |message|
      message.json_reactions.each do |r|
        message.user.reactions.create!(content: r['content'], user: message.user, message: message)
      end
    end
  end

  def destroy_all
    Reaction.delete_all
    Message.delete_all
    User.delete_all
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
