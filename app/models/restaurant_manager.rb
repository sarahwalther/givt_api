class RestaurantManager < User
  has_many :restaurants, foreign_key: :user_id

end
