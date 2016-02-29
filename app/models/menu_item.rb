class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :orders, dependent: :nullify
end
