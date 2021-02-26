class ApplicationComponent < ViewComponentReflex::Component
  def current_user
    if respond_to? :connection
      connection.current_user
    else
      helpers.current_user
    end&.reload
  end
end
