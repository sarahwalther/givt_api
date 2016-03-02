require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @manager = users(:manager)
    @manager2 = Manager.create(
      first_name: "user2",
      last_name: "user2",
      email: "user2@gmail.com",
      password: "hihihihi"
    )
  end

  test "should deny access without proper authentication" do
    get managers_url
    assert_response 401

    get manager_url(@manager)
    assert_response 401

    patch manager_url(@manager), params: manager_params(@manager)
    assert_response 401

    delete manager_url(@manager)
    assert_response 401
  end

  test "should deny access to managers index unless type admin" do
    get managers_url, headers: api_key(@manager)
    assert_response 401

    get managers_url, headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other manager's show unless type admin" do
    get manager_url(@manager2), headers: api_key(@manager)
    assert_response 401

    get manager_url(@manager2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other manager's update unless type admin" do
    patch manager_url(@manager2), params: manager_params(@admin), headers: api_key(@manager)
    assert_response 401

    patch manager_url(@manager2), params: manager_params(@manager2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other manager's delete unless type admin" do
    delete manager_url(@manager2), headers: api_key(@manager)
    assert_response 401

    assert_difference('Manager.count', -1) do
      delete manager_url(@manager2), headers: api_key(@manager2)
    end
    assert_response 204
  end

  test "should show manager" do
    get manager_url(@manager), headers: api_key(@manager)
    assert_response :success
  end

  test "should update manager" do
    patch manager_url(@manager), params: manager_params(@manager), headers: api_key(@manager)
    assert_response 200
  end

  test "should fail update manager if there is bad manager input" do
    patch manager_url(@manager), params: manager_params(@customer), headers: api_key(@manager)
    assert_response 422
  end

  test "should destroy manager" do
    assert_difference('Manager.count', -1) do
      delete manager_url(@manager), headers: api_key(@manager)
    end

    assert_response 204
  end

  private

  def manager_params(manager)
    {
      manager: {
        email: manager.email,
        first_name: manager.first_name,
        last_name: manager.last_name
      }
    }
  end

  def new_manager_params(manager)
    {
      manager: {
        email: manager.email,
        first_name: manager.first_name,
        last_name: manager.last_name,
        password: manager.password,
        type: manager.type
      }
    }
  end
end
