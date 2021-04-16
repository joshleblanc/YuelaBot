require 'ostruct'

class ApplicationComponent < ViewComponentReflex::Component
  extend Cedar::Component

  def initialize(**args)
    @props = OpenStruct.new(args)
  end

  def current_user
    if respond_to? :connection
      connection.current_user
    else
      helpers.current_user
    end&.reload
  end
end
