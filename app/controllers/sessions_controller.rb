class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    @user = User.login(auth_hash)
    cookies.encrypted[:user_id] = @user.id
    redirect_to '/'
  end

  def destroy
    cookies.encrypted[:user_id] = nil
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end