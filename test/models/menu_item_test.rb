require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    menu_item = MenuItem.new
    assert_not menu_item.valid?
    assert_equal [:restaurant, :name, :price], menu_item.errors.keys
  end
end
