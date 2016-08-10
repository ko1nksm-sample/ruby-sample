class CreateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :details do |t|
      t.integer :order_id
      t.string :product
      t.integer :quantity

      t.timestamps
    end
  end
end
