class Afk
  include DataMapper::Resource

  property :id, Serial
  property :message, String, length: 250

  belongs_to :user
end