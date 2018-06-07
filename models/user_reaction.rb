class UserReaction
  include DataMapper::Resource

  property :id, Serial
  property :regex, String
  property :output, Text
  property :created_at, Time
  property :creator, String

  attr_accessor :handler

  def run
    lambda do |event|
      event << event.message.sub(/#{regex}/, output)
    end
  end
end