class Crayta::GamesController < ApplicationController
  before_action :set_game, only: [:show, :rank]

  def index
    @pagy, @games = pagy(CraytaGame.order(visits: :desc))
  end

  def show
  end

  def search
  end

  def rank
  end

  private
  def set_game
    @game = CraytaGame.find(params[:id])
  end
end
