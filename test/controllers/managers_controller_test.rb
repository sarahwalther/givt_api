require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @manager = users(:manager)
    @restaurant = restaurants(:one)
    @manager2 = Manager.create(
      first_name: "user2",
      last_name: "user2",
      email: "user2@gmail.com",
      password: "hihihihi"
    )
    @new_restaurant = Restaurant.new({
      name: 'new Restaurant',
      description: 'new place',
      street_address: 'blah',
      city: 'Seattle',
      zipcode: '98101',
      phone_number: '387502638576'
    })
  end

  test "should deny access without proper authentication" do
    get manager_url(@manager)
    assert_response 401

    patch manager_url(@manager), params: manager_params(@manager)
    assert_response 401

    delete manager_url(@manager)
    assert_response 401

    get manager_restaurants_url(@manager)
    assert_response 401

    post manager_restaurants_url(@manager)
    assert_response 401

    get manager_restaurant_url(@manager, @restaurant)
    assert_response 401

    patch manager_restaurant_url(@manager, @restaurant)
    assert_response 401

    delete manager_restaurant_url(@manager, @restaurant)
    assert_response 401
  end

  test "should deny access to other managers' show unless type admin" do
    get manager_url(@manager2), headers: api_key(@manager)
    assert_response 401

    get manager_url(@manager2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other managers' update unless type admin" do
    patch manager_url(@manager2), params: manager_params(@admin), headers: api_key(@manager)
    assert_response 401

    patch manager_url(@manager2), params: manager_params(@manager2), headers: api_key(@admin)
    assert_response :success
  end

  test "should deny access to other managers' delete unless type admin" do
    delete manager_url(@manager2), headers: api_key(@manager)
    assert_response 401

    assert_difference('Manager.count', -1) do
      delete manager_url(@manager2), headers: api_key(@manager2)
    end
    assert_response 204
  end

  test "should deny access to other managers' restaurants" do
    # get manager_restaurants_url(@manager), headers: api_key(@manager2)
    # assert_response 401

    number_restaurants = Restaurant.count

    post manager_restaurants_url(@manager), headers: api_key(@manager2), params: new_restaurant_params(@new_restaurant)
    assert_response 401
    assert_equal number_restaurants, Restaurant.count

    put manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager2), params: new_restaurant_params(@new_restaurant)
    assert_response 401

    delete manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager2)
    assert_response 401
    assert_equal number_restaurants, Restaurant.count

    get manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager2)
    # assert_response 401
  end

  test "should show manager" do
    get manager_url(@manager), headers: api_key(@manager)
    assert_response :success
  end

  test "should update manager" do
    patch manager_url(@manager), params: manager_params(@manager), headers: api_key(@manager)
    assert_response :success
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

  test "should show all of a manager's restaurants" do
    get manager_restaurants_url(@manager), headers: api_key(@manager)
    assert_response :success
    assert_equal @manager.restaurants.count, JSON.parse(response.body).count
  end

  test "should show a manager's specific restaurant" do
    get manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager)
    assert_response :success
  end

  test "should delete a manager's specific restaurant" do
    assert_difference('@manager.restaurants.count', -1) do
      delete manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager)
    end
    assert_response 204
  end

  test "should update a manager's specific restaurant" do
    put manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager), params: new_restaurant_params(@new_restaurant)
    assert_response :success
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

  def new_restaurant_params(restaurant)
    {
      restaurant: {
        name: restaurant.name,
        description: restaurant.description,
        street_address: restaurant.street_address,
        city: restaurant.city,
        zipcode: restaurant.zipcode,
        phone_number: restaurant.phone_number
      }
    }
  end
end
