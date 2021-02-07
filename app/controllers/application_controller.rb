class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include CurrentHelper
end
