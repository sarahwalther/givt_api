class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates_presence_of :name, :street_address, :city, :zipcode
end
