class EmployeesController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate
  before_action :authenticate_admin, only: [:index]

  def index
    @employees = Employee.all
    render json: @employees
  end

  def show
    if @employee.api_key == auth_user.api_key || auth_user.type == "Admin"
      render json: @employee
    else
      render_unauthorized
    end
  end

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

  def destroy
    if @employee.api_key == auth_user.api_key || auth_user.type == "Admin"
      @employee.destroy
    else
      render_unauthorized
    end
  end

  private

    def set_user
      @employee = Employee.find(params[:id])
    end
    def set_restaurant
      @employee = Restaurant.find(params[:restaurant_id])
    end

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
