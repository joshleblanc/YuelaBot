class ApplicationComponent < ViewComponentReflex::Component
  def current_user
    helpers.current_user
  end
end