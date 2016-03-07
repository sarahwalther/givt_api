class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET restaurant/:restaurant_id/orders
  # GET customers/:customer_id/orders
  def index
    if params[:customer_id]
      @orders = Customer.find(params[:customer_id]).orders
    elsif params[:restaurant_id]
      @orders = Restaurant.find(params[:restaurant_id]).orders
    end
    render json: @orders
  end

  # GET restaurant/:restaurant_id/orders/1
  # GET customers/:customer_id/orders/1
  def show
    render json: @order
  end

  # POST restaurant/:restaurant_id/orders
  # POST customers/:customer_id/orders
  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT restaurant/:restaurant_id/orders/1
  # PATCH/PUT customers/:customer_id/orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE restaurant/:restaurant_id/orders/1
  # DELETE customers/:customer_id/orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_customer
      @customer = Customer.find(params[:customer_id])
    end

    def set_restaurant
      @customer = Customer.find(params[:restaurant_id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:pick_up_name, :user_id, :menu_item_id, :id)
    end
end
