class MessageLoader
  attr_reader :participants

  def initialize
    @participants = Dir[Rails.root.join('db', 'files', '*.json')].map do |message_json|
      JSON.load_file(message_json)['participants'].uniq.map { |p| p['name'] }
    end
  end
end
