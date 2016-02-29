require 'test_helper'

class MenuItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menu_item = menu_items(:one)
  end

  test "should get index" do
    get menu_items_url
    assert_response :success
  end

  test "should create menu_item" do
    assert_difference('MenuItem.count') do
      post menu_items_url, params: { menu_item: { description: @menu_item.description, image_url: @menu_item.image_url, name: @menu_item.name, price: @menu_item.price, restaurant_id: @menu_item.restaurant_id } }
    end

    assert_response 201
  end

  test "should show menu_item" do
    get menu_item_url(@menu_item)
    assert_response :success
  end

  test "should update menu_item" do
    patch menu_item_url(@menu_item), params: { menu_item: { description: @menu_item.description, image_url: @menu_item.image_url, name: @menu_item.name, price: @menu_item.price, restaurant_id: @menu_item.restaurant_id } }
    assert_response 200
  end

  test "should destroy menu_item" do
    assert_difference('MenuItem.count', -1) do
      delete menu_item_url(@menu_item)
    end

    assert_response 204
  end
end
