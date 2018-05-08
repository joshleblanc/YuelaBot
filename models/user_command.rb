class UserCommand
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :input, Text
  property :output, Text
  property :creator, String
  property :created_at, DateTime

  def run
    lambda do |_, *args|
      test = args.join(' ')
      if input == '.*' || test.match(/#{input}/)
        test.sub(/#{input}/, output)
      end
    end
  end
end
