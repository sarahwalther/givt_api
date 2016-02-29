class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :orders, dependent: :nullify

  validates_presence_of :name, :price
end
