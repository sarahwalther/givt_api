class Order < ApplicationRecord
  belongs_to :customer, class_name: "Customer", foreign_key: :user_id
  belongs_to :menu_item
end
