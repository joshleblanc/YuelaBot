class UserCommand
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :input, String
  property :output, String
  property :creator, String
  property :created_at, DateTime
end