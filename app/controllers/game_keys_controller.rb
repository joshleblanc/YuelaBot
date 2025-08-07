class GameKeysController < ApplicationController
  before_action :protect
  before_action :set_game_key, only: %i[ show edit update destroy ]
  before_action :validate_owner, only: %i[edit update destroy]

  # GET /game_keys or /game_keys.json
  def index
    @pagy, @game_keys = pagy(GameKey.eager_load(:servers).where(claimed: false, servers: current_user.servers).order(created_at: :desc))
  end

  # GET /game_keys/1 or /game_keys/1.json
  def show
  end

  # GET /game_keys/new
  def new
    @game_key = GameKey.new
    session[:model] = @game_key unless @stimulus_reflex
  end

  # GET /game_keys/1/edit
  def edit
  end

  # POST /game_keys or /game_keys.json
  def create
    @game_key = GameKey.new(game_key_params)

    respond_to do |format|
      if @game_key.save
        format.html { redirect_to game_keys_url, notice: "Game key was successfully created." }
        format.json { render :show, status: :created, location: @game_key }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_keys/1 or /game_keys/1.json
  def update
    respond_to do |format|
      if @game_key.update(game_key_params)
        format.html { redirect_to @game_key, notice: "Game key was successfully updated." }
        format.json { render :show, status: :ok, location: @game_key }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /game_keys/:id/claim
  def claim
    @game_key = GameKey.unclaimed
                       .joins(:servers)
                       .where(servers: { id: current_user.servers.select(:id) })
                       .find_by(id: params[:id])

    return head :not_found unless @game_key

    @game_key.claim!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to game_keys_path, notice: t("game_keys.claimed", default: "Game key claimed!") }
    end
  end

  # DELETE /game_keys/1 or /game_keys/1.json
  def destroy
    @game_key.destroy
    respond_to do |format|
      format.html { redirect_to game_keys_url, notice: "Game key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_key
    @game_key = GameKey.find(params[:id])
    session[:model] = @game_key unless @stimulus_reflex
  end

  # Only allow a list of trusted parameters through.
  def game_key_params
    params.require(:game_key).permit(:key, :name, server_ids: [])
  end

  # todo: actually add the creator to these, and check it
  def validate_owner
    redirect_back(fallback_location: root_url)
  end
end
