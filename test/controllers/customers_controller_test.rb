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
  end

  test "should deny access without proper authentication" do
    get customers_url
    assert_response 401

    get customer_url(@customer)
    assert_response 401

    patch customer_url(@customer), params: customer_params(@customer)
    assert_response 401

    delete customer_url(@customer)
    assert_response 401
  end

  test "should deny access to customers index unless type admin" do
    get customers_url, headers: api_key(@customer2)
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

  test "should get index" do
    get customers_url, headers: api_key(@admin)
    assert_response :success
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
end
