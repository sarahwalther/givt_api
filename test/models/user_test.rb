require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    user = User.new
    assert_not user.valid?
    assert_equal [:first_name, :last_name, :email], user.errors.keys
  end
end
