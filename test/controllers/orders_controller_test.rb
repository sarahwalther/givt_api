require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @customer = users(:customer)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, params: { order: { user_id: @order.user_id, menu_item_id: @order.menu_item_id, pick_up_name: @order.pick_up_name } }
    end

    assert_response 201
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { user_id: @order.user_id, menu_item_id: @order.menu_item_id, pick_up_name: @order.pick_up_name } }
    assert_response 200
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_response 204
  end
end
