require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
    @user = users(:one)
  end

  test "should get index" do
    get restaurants_url, {
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post restaurants_url, {
        params: { restaurant: { city: @restaurant.city, description: @restaurant.description, latitude: @restaurant.latitude, longitude: @restaurant.longitude, name: @restaurant.name, phone_number: @restaurant.phone_number, street_address: @restaurant.street_address, zipcode: @restaurant.zipcode } },
        headers: { 'X-Api-Key' => @user.api_key }
      }
    end

    assert_response 201
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant), {
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), {
      params: { restaurant: { city: @restaurant.city, description: @restaurant.description, latitude: @restaurant.latitude, longitude: @restaurant.longitude, name: @restaurant.name, phone_number: @restaurant.phone_number, street_address: @restaurant.street_address, zipcode: @restaurant.zipcode } },
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response 200
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete restaurant_url(@restaurant), {
        headers: { 'X-Api-Key' => @user.api_key }
      }
    end

    assert_response 204
  end
end
