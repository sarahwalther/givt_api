require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @customer2 = User.create(
      first_name: "user2",
      last_name: "user2",
      type: "Manager",
      email: "user2@gmail.com",
      password: "hihihihi"
    )
  end

  test "should be able to login" do
    post login_users_url, params: { email: @customer2.email, password: @customer2.password }
    assert_response :success
  end

  test "should deny access with bad credentials to login" do
    post login_users_url, params: { email: @customer2.email, password: @customer.password }
    assert_response 401
  end

  test "should create user" do
    new_user = User.new({
      first_name:"test",
      last_name: "test",
      type: "Customer",
      email: "test@test.com",
      password: "test123",
      password_confirmation: "test123"
    })
    assert_difference('User.count') do
      post users_url, params: new_user_params(new_user)
    end

    assert_response 201
  end

  test "should fail on incomplete create user" do
    current_user_count = User.count
    new_user = User.new({
      first_name:"test",
      email: "test@test2.com",
      password: "test123"
    })
    post users_url, params: new_user_params(new_user)

    assert_equal current_user_count, User.count
    assert_response 422
  end

  test "should fail on create Admin" do
    current_user_count = User.count
    new_admin = User.new({
      first_name:"test",
      last_name: "test",
      type: "Admin",
      email: "test@test.com",
      password: "test123",
      password_confirmation: "test123"
    })
    post users_url, params: new_user_params(new_admin)

    assert_equal current_user_count, User.count
    assert_response 422
  end

  private

  def new_user_params(user)
    {
      user: {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        password: user.password,
        type: user.type
      }
    }
  end
end
