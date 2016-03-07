require 'test_helper'

class MenuItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
    @menu_item = menu_items(:one)
  end

  test "should get index" do
    get restaurant_menu_items_url(@restaurant)
    assert_response :success
  end

  test "should create menu_item" do
    assert_difference('MenuItem.count') do
      post restaurant_menu_items_url(@restaurant), params: { menu_item: { description: @menu_item.description, image_url: @menu_item.image_url, name: @menu_item.name, price: @menu_item.price, restaurant_id: @menu_item.restaurant_id } }
    end

    assert_response 201
  end

  test "should show menu_item" do
    get restaurant_menu_item_url(@restaurant, @menu_item)
    assert_response :success
  end

  test "should update menu_item" do
    patch restaurant_menu_item_url(@restaurant, @menu_item), params: { menu_item: { description: @menu_item.description, image_url: @menu_item.image_url, name: @menu_item.name, price: @menu_item.price, restaurant_id: @menu_item.restaurant_id } }
    assert_response 200
  end

  test "should destroy menu_item" do
    assert_difference('MenuItem.count', -1) do
      delete restaurant_menu_item_url(@restaurant, @menu_item)
    end

    assert_response 204
  end
end
