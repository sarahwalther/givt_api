class UsersController < ApplicationController

  def login
    @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if @user
      render json: @user
    else
      render json: 'Wrong email and/or password.', status: 401
    end
  end

  def create
    @user = User.new(user_params)

    if @user.type != "Admin" && @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :type
      )
    end
end
