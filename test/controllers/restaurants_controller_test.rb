require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
    @manager = users(:manager)
    @employee = users(:employee)
    @customer = users(:customer)
    @admin = users(:admin)
  end

  test "should deny access without proper authentication" do
    get restaurants_url
    assert_response 401

    get restaurant_url(@restaurant)
    assert_response 401

    get manager_restaurants_url(@manager)
    assert_response 401

    post manager_restaurants_url(@manager), params: restaurant_params(@restaurant, @manager)
    assert_response 401

    get manager_restaurant_url(@manager, @restaurant)
    assert_response 401

    patch manager_restaurant_url(@manager, @restaurant), params: restaurant_params(@restaurant, @manager)
    assert_response 401

    delete manager_restaurant_url(@restaurant)
    assert_response 401
  end

  test "should get index" do
    get restaurants_url, headers: api_key(@customer)
    assert_response :success
  end

  test "should only return a manager's restaurants" do
    get manager_restaurants_url(@manager), headers: api_key(@manager)
    assert_equal(JSON.parse(body).length, @manager.restaurants.length)
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post manager_restaurants_url(@manager), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@manager) }
    end
    assert_response 201
  end

  test "only admins and managers should create restaurant" do
    assert_difference('Restaurant.count') do
      post manager_restaurants_url(@manager), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@admin) }
    end
    assert_response 201

    assert_difference('Restaurant.count') do
      post manager_restaurants_url(@manager), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@manager) }
    end
    assert_response 201

    post manager_restaurants_url(@manager), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@customer) }
    assert_response 401

    post manager_restaurants_url(@manager), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@employee) }
    assert_response 401
  end

  test "should fail on incomplete create restaurant" do
    current_restaurant_count = Restaurant.count
    post manager_restaurants_url(@manager), params: { restaurant: { name:"test" } }, headers: api_key(@admin)
    assert_equal current_restaurant_count, Restaurant.count
    assert_response 422
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant), headers: api_key(@customer)
    assert_response :success
  end

  test "should update restaurant" do
    patch manager_restaurant_url(@manager, @restaurant), { params: restaurant_params(@restaurant, @manager) , headers: api_key(@manager) }
    assert_response 200
  end

  test "should fail update restaurant if there is bad user restaurant" do
    patch manager_restaurant_url(@manager, @restaurant), params: { restaurant: { user_id: "32jrawfa" } }, headers: api_key(@manager)
    assert_response 422
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete manager_restaurant_url(@manager, @restaurant), headers: api_key(@manager)
    end

    assert_response 204
  end

  private

  def restaurant_params(restaurant, user)
    {
      restaurant: {
        city: restaurant.city,
        description: restaurant.description,
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        name: restaurant.name,
        phone_number: restaurant.phone_number,
        street_address: restaurant.street_address,
        zipcode: restaurant.zipcode,
        user_id: user.id
      }
    }
  end
end
