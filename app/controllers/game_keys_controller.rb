class GameKeysController < ApplicationController
  before_action :set_game_key, only: %i[ show edit update destroy ]
  before_action :protect

  # GET /game_keys or /game_keys.json
  def index
    @game_keys = GameKey.eager_load(:servers).where(claimed: false, servers: current_user.servers).order(created_at: :desc)
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
end
