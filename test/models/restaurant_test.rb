require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    restaurant = Restaurant.new
    assert_not restaurant.valid?
    assert_equal [:name, :street_address, :city, :zipcode], restaurant.errors.keys
  end
end
