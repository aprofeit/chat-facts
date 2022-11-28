class ETL
  def import_users
    user_params = participants.map do |p|
      { name: p }
    end

    User.create!(user_params)
  end

  def destroy_all
    User.destroy_all
  end

  def import_messages
    messages.map do |message|
      m = Message.new(
        user: User.find_by(name: message['sender_name']),
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

  def message_files
    Dir.glob(Rails.root.join('db', 'files', '*.json'))
  end

  def participants
    JSON.load_file(message_files.first)['participants'].map(&:values)
  end

  def messages
    return @messages if @messages

    @messages = message_files.flat_map do |f|
      JSON.load_file(f)['messages']
    end
  end
end
