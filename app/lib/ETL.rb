class ETL
  def import_users
    user_params = participants.map do |p|
      { name: p.first }
    end

    user_params.each do |up|
      User.find_or_create_by(up)
    end
  end

  def import_messages
    json_messages.map do |message|
      user = User.find_or_create_by(name: message['sender_name'])

      m = user.messages.build(
        sent_at: Time.at(message['timestamp_ms'] / 1000),
        content: message['content'],
        kind: message['type'],
        is_unsent: message['is_unsent'],
        is_taken_down: message['is_taken_down'],
        bumped_message_metadata: message['bumped_message_metadata'],
        json_reactions: message['reactions']
      )
    end.each(&:save)
  end

  def import_reactions
    Message.where.not(json_reactions: nil).find_each do |message|
      message.json_reactions.each do |r|
        message.user.reactions.create!(content: r['content'], user: message.user, message: message)
      end
    end
  end

  def delete_all
    Reaction.delete_all
    Message.delete_all
    User.delete_all
  end

  def import
    import_users
    import_messages
    import_reactions
  end

  def reset_import
    delete_all
    import
  end

  def message_files
    Rails.application.config.x.messages_path
  end

  def participants
    message_files.flat_map { |f| JSON.load_file(f)['participants'] }.map(&:values)
  end

  def json_messages
    return @messages if @messages

    @messages = message_files.flat_map do |f|
      JSON.load_file(f)['messages']
    end
  end
end
