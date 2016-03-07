require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @customer2 = Customer.create(
      first_name: "customer2",
      last_name: "customer2",
      email: "customer2@gmail.com",
      password: "hihihihi"
    )
    @order = orders(:one)
    @new_order = Order.new(
      pick_up_name: "test",
      user_id: "test",
      menu_item_id: "test"
    )
  end

  test "should deny access without proper authentication" do
    get customer_url(@customer)
    assert_response 401

    patch customer_url(@customer), params: customer_params(@customer)
    assert_response 401

    delete customer_url(@customer)
    assert_response 401

    get customer_orders_url(@customer)
    assert_response 401

    post customer_orders_url(@customer), params: new_order_params(@new_order)
    assert_response 401

    get customer_order_url(@customer, @order)
    assert_response 401
  end

  test "should deny access to other customer's show unless type admin" do
    get customer_url(@customer), headers: api_key(@customer2)
    assert_response 401

    get customer_url(@customer2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other customer's update unless type admin" do
    patch customer_url(@customer), params: customer_params(@admin), headers: api_key(@customer2)
    assert_response 401

    patch customer_url(@customer2), params: customer_params(@customer2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other customer's delete unless type admin" do
    delete customer_url(@customer), headers: api_key(@customer2)
    assert_response 401

    assert_difference('Customer.count', -1) do
      delete customer_url(@customer2), headers: api_key(@admin)
    end
    assert_response 204
  end

  test "should show customer" do
    get customer_url(@customer), headers: api_key(@customer)
    assert_response :success
  end

  test "should update customer" do
    patch customer_url(@customer), params: customer_params(@customer), headers: api_key(@customer)
    assert_response 200
  end

  test "should fail update customer if there is bad customer input" do
    patch customer_url(@customer), params: customer_params(@customer2), headers: api_key(@customer)
    assert_response 422
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete customer_url(@customer), headers: api_key(@admin)
    end
    assert_response 204
  end

  test "a customer should be able to create orders" do
    post customer_orders_url(@customer), headers: api_key(@customer), params: new_order_params(@new_order)
  end

  test "should fail creating a customer's order if there is bad input" do
    post customer_orders_url(@customer), headers: api_key(@customer), params: {order: {pick_up_name: 9842039482} }
    assert_response 422
  end

  test "should deny access to other customers' create orders unless type admin" do
    customer_order_count = @customer.orders.count
    post customer_orders_url(@customer), headers: api_key(@customer2), params: new_order_params(@new_order)
    assert_equal customer_order_count, @customer.orders.count
    assert_response 401
  end

  test "should be able to see all of a specific customer's orders" do
    get customer_orders_url(@customer), headers: api_key(@customer)
    assert_response :success
  end

  test "should deny access to other customers' orders unless type admin" do
    get customer_orders_url(@customer), headers: api_key(@admin)
    assert_response :success

    get customer_orders_url(@customer), headers: api_key(@customer2)
    assert_response 401
  end

  test "a customer should be able to see a specific order" do
    get customer_order_url(@customer, @order), headers: api_key(@customer)
    assert_response :success
  end

  test "should deny access to a single customers' order unless type admin" do
    get customer_order_url(@customer, @order), headers: api_key(@admin)
    assert_response :success

    get customer_order_url(@customer, @order), headers: api_key(@customer2)
    assert_response 401
  end

  private

  def customer_params(customer)
    {
      customer: {
        email: customer.email,
        first_name: customer.first_name,
        last_name: customer.last_name
      }
    }
  end

  def new_customer_params(customer)
    {
      customer: {
        email: customer.email,
        first_name: customer.first_name,
        last_name: customer.last_name,
        password: customer.password,
        type: customer.type
      }
    }
  end

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
