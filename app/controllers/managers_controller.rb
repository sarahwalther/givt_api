class ManagersController < ApplicationController
  before_action :authenticate, :set_manager
  before_action -> { authorize @manager }

  def show
      render json: @manager
  end

  def update
      if @manager.update(manager_params)
        render json: @manager
      else
        render json: @manager.errors, status: :unprocessable_entity
      end
  end

  def destroy
      @manager.destroy
  end

  private

    def set_manager
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
