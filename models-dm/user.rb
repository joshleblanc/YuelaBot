class User
  include DataMapper::Resource

  property :id, Integer, key: true
  property :name, String

  has 1, :afk
  has n, :birthdays
end