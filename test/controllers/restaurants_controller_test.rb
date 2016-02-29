require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
    @customer = users(:customer)
  end

  test "should deny access without proper authentication" do
    get restaurants_url
    assert_response 401

    post restaurants_url, params: restaurant_params(@restaurant)
    assert_response 401

    get restaurant_url(@restaurant)
    assert_response 401

    patch restaurant_url(@restaurant), params: restaurant_params(@restaurant)
    assert_response 401

    delete restaurant_url(@restaurant)
    assert_response 401
  end

  test "should get index" do
    get restaurants_url, headers: api_key(@customer)
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post restaurants_url, { params: restaurant_params(@restaurant) , headers: api_key(@customer) }
    end

    assert_response 201
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant), headers: api_key(@customer)
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), { params: restaurant_params(@restaurant) , headers: api_key(@customer) }
    assert_response 200
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete restaurant_url(@restaurant), headers: api_key(@customer)
    end

    assert_response 204
  end

  private

  def restaurant_params(restaurant)
    {
      restaurant: {
        city: restaurant.city,
        description: restaurant.description,
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        name: restaurant.name,
        phone_number: restaurant.phone_number,
        street_address: restaurant.street_address,
        zipcode: restaurant.zipcode
      }
    }
  end
end
