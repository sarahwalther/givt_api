class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :pick_up_name
      t.references :user, foreign_key: true
      t.references :menu_item, foreign_key: true

      t.timestamps
    end
  end
end
