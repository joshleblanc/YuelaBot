class Crayta::GamesController < ApplicationController
  before_action :set_game, only: [:show, :timeline, :visits_history]

  def index
    query = CraytaGame.order(visits: :desc)
    if params[:q]
      query = query.where(CraytaGame.arel_table[:name].matches("%#{params[:q]}%"))
    end
    @pagy, @games = pagy(query)
  end

  def show
  end

  def timeline
    render json: @game.times_in_rails
  end

  def visits_history
    data = @game.versions.group_by_day(&:created_at).transform_values do |value|
      value.map { |a| a.reify.visits }
    end
    render json: data
  end

  private
  def set_game
    @game = CraytaGame.find(params[:id])
  end
end
