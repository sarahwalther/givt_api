class CustomersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate
  before_action :authenticate_admin, only: [:index]

  def index
    @customers = Customer.all
    render json: @customers
  end

  def show
    if @customer.api_key == auth_user.api_key || auth_user.type == "Admin"
      render json: @customer
    else
      render_unauthorized
    end
  end

  def update
    if @customer.api_key == auth_user.api_key || auth_user.type == "Admin"
      if @customer.update(customer_params)
        render json: @customer
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  def destroy
    if @customer.api_key == auth_user.api_key || auth_user.type == "Admin"
      @customer.destroy
    else
      render_unauthorized
    end
  end

  private

    def set_user
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :type
      )
    end
end
