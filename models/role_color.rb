class RoleColor
  include DataMapper::Resource

  property :id, Serial
  property :color, String
  property :name, String
  property :server, Integer
end