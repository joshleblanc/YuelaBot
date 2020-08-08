module Middleware
  def test(event, *args)
    p "working"
    args
  end
end
