class CreateCigaretteBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :cigarette_brands do |t|
      t.string :name, null: false
      t.integer :price_per_pack, null: false
      t.integer :quantity_per_pack, null: false

      t.timestamps
    end
    add_index :cigarette_brands, :name, unique: true
  end
end
