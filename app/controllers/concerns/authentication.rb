module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private
    def authenticate
      if authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
        Current.user = authenticated_user
      end
    end
end
