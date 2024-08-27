class CreateCigarettes < ActiveRecord::Migration[7.1]
  def change
    create_table :cigarettes do |t|
      t.string :brand, null: false
      t.integer :quantity_per_pack, null: false
      t.integer :price_per_pack, null: false
      t.decimal :price_per_cigarette, precision: 4, scale: 2, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
