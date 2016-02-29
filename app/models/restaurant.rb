class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  belongs_to :manager, class_name: "RestaurantManager", foreign_key: :user_id

  validates_presence_of :name, :street_address, :city, :zipcode
end
