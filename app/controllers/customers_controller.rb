class CustomersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate
  before_action :authenticate_admin, only: [:index]

  # GET /customers
  def index
    @customers = Customer.all
    render json: @customers
  end

  # GET /customers/1
  def show
    if @customer.api_key == auth_user.api_key || auth_user.type == "Admin"
      render json: @customer
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /customers/1
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

  # DELETE /customers/1
  def destroy
    if @customer.api_key == auth_user.api_key || auth_user.type == "Admin"
      @customer.destroy
    else
      render_unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
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
