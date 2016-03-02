class ManagersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate
  before_action :authenticate_admin, only: [:index]

  # GET /managers
  def index
    @managers = Manager.all
    render json: @managers
  end

  # GET /managers/1
  def show
    if @manager.api_key == auth_user.api_key || auth_user.type == "Admin"
      render json: @manager
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /managers/1
  def update
    if @manager.api_key == auth_user.api_key || auth_user.type == "Admin"
      if @manager.update(manager_params)
        render json: @manager
      else
        render json: @manager.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # DELETE /managers/1
  def destroy
    if @manager.api_key == auth_user.api_key || auth_user.type == "Admin"
      @manager.destroy
    else
      render_unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @manager = Manager.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manager_params
      params.require(:manager).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :type
      )
    end
end
