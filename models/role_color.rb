class RoleColor
  include DataMapper::Resource

  property :id, Serial
  property :color, String
  property :name, String
end