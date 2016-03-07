require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @restaurant = restaurants(:one)
    @employee = users(:employee)
    @employee2 = Employee.create(
      first_name: "employee2",
      last_name: "employee2",
      email: "employee2@gmail.com",
      password: "hihihihi",
      restaurant: @restaurant
    )
  end

  test "should deny access without proper authentication" do
    get restaurant_employees_url(@restaurant)
    assert_response 401

    get restaurant_employee_url(@restaurant, @employee)
    assert_response 401

    patch restaurant_employee_url(@restaurant, @employee), params: employee_params(@employee)
    assert_response 401

    delete restaurant_employee_url(@restaurant, @employee)
    assert_response 401
  end

  test "should deny access to employees index unless type admin" do
    get restaurant_employees_url(@restaurant, ), headers: api_key(@employee2)
    assert_response 401
  end

  test "should deny access to other employee's show unless type admin" do
    get restaurant_employee_url(@restaurant, @employee), headers: api_key(@employee2)
    assert_response 401

    get restaurant_employee_url(@restaurant, @employee2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other employee's update unless type admin" do
    patch restaurant_employee_url(@restaurant, @employee), params: employee_params(@admin), headers: api_key(@employee2)
    assert_response 401

    patch restaurant_employee_url(@restaurant, @employee2), params: employee_params(@employee2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other employee's delete unless type admin" do
    delete restaurant_employee_url(@restaurant, @employee), headers: api_key(@employee2)
    assert_response 401

    assert_difference('Employee.count', -1) do
      delete restaurant_employee_url(@restaurant, @employee2), headers: api_key(@admin)
    end
    assert_response 204
  end

  test "should get index" do
    get restaurant_employees_url(@restaurant), headers: api_key(@admin)
    assert_response :success
  end

  test "should show employee" do
    get restaurant_employee_url(@restaurant, @employee), headers: api_key(@employee)
    assert_response :success
  end

  test "should update employee" do
    patch restaurant_employee_url(@restaurant, @employee), params: employee_params(@employee), headers: api_key(@employee)
    assert_response 200
  end

  test "should fail update employee if there is bad employee input" do
    patch restaurant_employee_url(@restaurant, @employee), params: employee_params(@employee2), headers: api_key(@employee)
    assert_response 422
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete restaurant_employee_url(@restaurant, @employee), headers: api_key(@admin)
    end
    assert_response 204
  end

  private

  def employee_params(employee)
    {
      employee: {
        email: employee.email,
        first_name: employee.first_name,
        last_name: employee.last_name
      }
    }
  end

  def new_employee_params(employee)
    {
      employee: {
        email: employee.email,
        first_name: employee.first_name,
        last_name: employee.last_name,
        password: employee.password,
        type: employee.type
      }
    }
  end
end
