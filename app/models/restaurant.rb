class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  belongs_to :manager, class_name: "Manager", foreign_key: :user_id
  has_many :employees, class_name: "Employee", foreign_key: :restaurant_id, dependent: :nullify

  validates_presence_of :name, :street_address, :city, :zipcode
end
