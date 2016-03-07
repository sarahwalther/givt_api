require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @customer_orders_url = users(:customer)
    @customer = users(:customer)
    @order = orders(:one)
    @menu_item = menu_items(:one)
    @new_order = Order.new(
      pick_up_name: "test",
      user_id: @customer.id,
      menu_item_id: @menu_item.id
    )
  end

  test "should deny access without proper authentication" do
    get customer_orders_url(@customer)
    assert_response 401

    post customer_orders_url(@customer), params: new_order_params(@new_order)
    assert_response 401

    get customer_order_url(@customer, @order)
    assert_response 401
  end

  test "should get index" do
    get customer_orders_url(@customer), headers: api_key(@customer)
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post customer_orders_url(@customer), headers: api_key(@customer), params: new_order_params(@new_order)
    end

    assert_response 201
  end

  test "should show order" do
    get customer_order_url(@customer, @order), headers: api_key(@customer)
    assert_response :success
  end

  private

  def new_order_params(order)
    {
      order: {
        pick_up_name: order.pick_up_name,
        user_id: order.user_id,
        menu_item_id: order.menu_item_id
      }
    }
  end
end
