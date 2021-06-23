class Crayta::UsersController < ApplicationController
  before_action :set_user, only: [:games]

  def index
    query = CraytaUser.order(crayta_games_count: :desc)
    if params[:q] 
      query = query.where(CraytaUser.arel_table[:name].matches("%#{params[:q]}%"))
    end
    @pagy, @users = pagy(query)
  end
  
  def games
    @pagy, @games = pagy(@user.crayta_games.order(visits: :desc))
  end

  private

  def set_user
    @user = CraytaUser.find(params[:id])
  end
end
