class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  before_action :authenticate

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    if auth_user.type == "Manager"
      render json: auth_user.restaurants
    else
      render json: @restaurants
    end
  end

  # GET /restaurants/1
  def show
    render json: @restaurant
  end

  # POST /restaurants
  def create
    if auth_user.type == "Manager" || auth_user.type == "Admin"
      @restaurant = Restaurant.new(restaurant_params)

      if @restaurant.save
        render json: @restaurant, status: :created, location: @restaurant
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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
