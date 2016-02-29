class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.float :latitude
      t.float :longitude
      t.string :street_address
      t.string :city
      t.string :zipcode
      t.string :phone_number

      t.timestamps
    end
  end
end
