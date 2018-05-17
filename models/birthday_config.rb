class BirthdayConfig
  include DataMapper::Resource

  property :id, Serial
  property :server, Integer
  property :channel, Integer
  property :message, String, length: 500

end