class UserReactionsController < ApplicationController
  before_action :protect
  before_action :set_user_reaction, only: %i[ show edit update destroy ]
  before_action :validate_owner, only: %i[edit update destroy]

  # GET /user_reactions or /user_reactions.json
  def index
    @user_reactions = UserReaction.all
  end

  # GET /user_reactions/1 or /user_reactions/1.json
  def show
  end

  # GET /user_reactions/new
  def new
    @user_reaction = UserReaction.new
    session[:model] = @user_reaction unless @stimulus_reflex
  end

  # GET /user_reactions/1/edit
  def edit
  end

  # POST /user_reactions or /user_reactions.json
  def create
    @user_reaction = UserReaction.new(user_reaction_params)

    respond_to do |format|
      if @user_reaction.save
        format.html { redirect_to @user_reaction, notice: "User reaction was successfully created." }
        format.json { render :show, status: :created, location: @user_reaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_reactions/1 or /user_reactions/1.json
  def update
    respond_to do |format|
      if @user_reaction.update(user_reaction_params)
        format.html { redirect_to @user_reaction, notice: "User reaction was successfully updated." }
        format.json { render :show, status: :ok, location: @user_reaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_reactions/1 or /user_reactions/1.json
  def destroy
    @user_reaction.destroy
    respond_to do |format|
      format.html { redirect_to user_reactions_url, notice: "User reaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_reaction
      @user_reaction = UserReaction.find(params[:id])
      session[:model] = @user_reaction unless @stimulus_reflex
    end

    # Only allow a list of trusted parameters through.
    def user_reaction_params
      params.require(:user_reaction).permit(:regex, :output, server_ids: [])
    end

  def validate_owner
    redirect_back(fallback_location: root_url) unless current_user == @user_reaction.user
  end
end
