class CreateMenuItems < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :image_url
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
