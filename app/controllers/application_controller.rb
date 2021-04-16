class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include CurrentHelper

  def protect
    redirect_to root_url unless Current.user
  end
end
