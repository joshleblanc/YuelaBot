class Crayta::GamesController < ApplicationController
  before_action :set_game, only: [:show, :timeline]

  def index
    @pagy, @games = pagy(CraytaGame.order(visits: :desc))
  end

  def show
  end

  def search
  end

  def timeline
    render json: @game.times_in_rails
  end

  private
  def set_game
    @game = CraytaGame.find(params[:id])
  end
end
