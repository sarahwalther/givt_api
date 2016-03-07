class RestaurantsController < ApplicationController
  before_action :authenticate, :set_manager
  before_action :set_restaurant, only: [:show, :update, :destroy]
  before_action -> { authorize @manager }, except: [:index, :show]
  before_action only: [:index, :show] do
    render_unauthorized if @manager && @manager != auth_user
  end

  def index
    if @manager
      @restaurants = @manager.restaurants
    elsif auth_user.customer? || auth_user.admin?
      @restaurants = Restaurant.all
    end
    render json: @restaurants
  end

  def show
    if @manager == @restaurant.manager
      render json: @restaurant
    elsif auth_user.customer? || auth_user.admin?
      render json: @restaurant
    else
      render_unauthorized
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: @restaurant, status: :created, location: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy
  end

  private
    def set_manager
      @manager = Manager.find(params[:manager_id]) if params[:manager_id]
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def restaurant_params
      params.require(:restaurant).permit(
        :name,
        :description,
        :latitude,
        :longitude,
        :street_address,
        :city,
        :zipcode,
        :phone_number,
        :user_id
      )
    end
end
