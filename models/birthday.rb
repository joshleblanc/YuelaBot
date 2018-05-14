class Birthday
  include DataMapper::Resource

  property :id, Serial
  property :month, Integer
  property :day, Integer
  property :channel, Integer

  belongs_to :user

  def to_s
    "#{user.name}: #{month}/#{day}"
  end
end