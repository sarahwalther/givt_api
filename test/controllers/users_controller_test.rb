require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url, {
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, {
        params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name } }
      }
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), {
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), {
      params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name } },
      headers: { 'X-Api-Key' => @user.api_key }
    }
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), {
        headers: { 'X-Api-Key' => @user.api_key }
      }
    end

    assert_response 204
  end
end
