class AfksController < ApplicationController
  before_action :set_afk, only: %i[ destroy ]

  # GET /afks/new
  def new
    @afk = Afk.new
    @afk.user = current_user
  end
  def edit
  end

  # POST /afks or /afks.json
  def create
    @afk = Afk.new(afk_params)
    @afk.user = current_user

    respond_to do |format|
      if @afk.save
        format.html { redirect_to root_path, notice: "You're now AFK!" }
        format.turbo_stream
        format.json { render :show, status: :created, location: @afk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @afk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /afks/1 or /afks/1.json
  def destroy
    if @afk == current_user.afk
      @afk.destroy
      current_user.reload
      @afk = nil
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Welcome back from AFK!" }
        format.turbo_stream
        format.json { head :no_content }
      end
    else
      head 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_afk
      @afk = Afk.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def afk_params
      params.require(:afk).permit(:message)
    end
end
