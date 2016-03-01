require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @customer = users(:customer)
    @user2 = User.create(
      first_name: "user2",
      last_name: "user2",
      type: "RestaurantManager",
      email: "user2@gmail.com",
      password: "hihihihi"
    )
  end

  test "should deny access without proper authentication" do
    get users_url
    assert_response 401

    get user_url(@user)
    assert_response 401

    patch user_url(@user), params: user_params(@user)
    assert_response 401

    delete user_url(@user)
    assert_response 401
  end

  test "should deny access to users index unless type admin" do
    get users_url, headers: api_key(@user2)
    assert_response 401
  end

  test "should be able to login" do
    post login_users_url, params: { email: @user2.email, password: @user2.password }
    assert_response :success
  end

  test "should get index" do
    get users_url, headers: api_key(@user)
    assert_response :success
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

  test "should show user" do
    get user_url(@user), headers: api_key(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: user_params(@user), headers: api_key(@user)
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), headers: api_key(@user)
    end

    assert_response 204
  end

  private

  def user_params(user)
    {
      user: {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name
      }
    }
  end

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
