class OrdersController < ApplicationController
  before_action :authenticate, :set_customer, :set_restaurant, :authorize_customer
  before_action :set_order, only: :show

  def index
    if @customer
      @orders = @customer.orders
    elsif @restaurant
      @orders = @restaurant.orders
    end
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def authorize_customer
      authorize @customer if @customer
    end

    def set_customer
      @customer = Customer.find(params[:customer_id]) if params[:customer_id]
    end

    def set_restaurant
      @customer = Customer.find(params[:restaurant_id]) if params[:restaurant_id]
    end

    def order_params
      params.require(:order).permit(:pick_up_name, :user_id, :menu_item_id, :id)
    end
end
