require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    order = Order.new
    assert_not order.valid?
    assert_equal [:customer, :menu_item, :pick_up_name], order.errors.keys
  end
end
