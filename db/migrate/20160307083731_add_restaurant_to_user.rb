class AddRestaurantToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :restaurant, foreign_key: true
  end
end
