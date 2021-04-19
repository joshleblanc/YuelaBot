class ApplicationController < ActionController::Base
  include Pagy::Backend

  include SetCurrentRequestDetails
  include Authentication
  include CurrentHelper

  def protect
    redirect_to root_url unless Current.user
  end
end
