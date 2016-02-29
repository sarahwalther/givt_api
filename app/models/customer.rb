class Customer < User
  has_many :orders, foreign_key: :user_id, class_name: "Order", dependent: :nullify
end
