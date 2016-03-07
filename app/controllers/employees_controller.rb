class EmployeesController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate
  before_action :authenticate_admin, only: [:index]

  # GET restaurant/:restaurant_id/employees
  def index
    @employees = Employee.all
    render json: @employees
  end

  # GET restaurant/:restaurant_id/employees/1
  def show
    if @employee.api_key == auth_user.api_key || auth_user.type == "Admin"
      render json: @employee
    else
      render_unauthorized
    end
  end

  # PATCH/PUT restaurant/:restaurant_id/employees/1
  def update
    if @employee.api_key == auth_user.api_key || auth_user.type == "Admin"
      if @employee.update(employee_params)
        render json: @employee
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # DELETE restaurant/:restaurant_id/employees/1
  def destroy
    if @employee.api_key == auth_user.api_key || auth_user.type == "Admin"
      @employee.destroy
    else
      render_unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @employee = Employee.find(params[:id])
    end
    def set_restaurant
      @employee = Restaurant.find(params[:restaurant_id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.require(:employee).permit(
        :restaurant_id,
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :type
      )
    end
end
