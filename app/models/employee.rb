class Employee < User
  belongs_to :restaurant, foreign_key: :restaurant_id
end
