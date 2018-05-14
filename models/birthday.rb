class Birthday
  include DataMapper::Resource

  property :id, Serial
  property :user, String
  property :month, Integer
  property :day, Integer

  def to_s
    "#{user}: #{month}/#{day}"
  end
end