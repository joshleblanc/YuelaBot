class User
  include DataMapper::Resource

  property :id, Integer, key: true
  property :name, String

  has n, :birthdays
end