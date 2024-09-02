class CreateSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :smoking_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cigarette, null: false, foreign_key: true
      t.decimal :price_per_cigarette, precision: 4, scale: 2, null: false
      t.datetime :smoked_at, null: false

      t.timestamps
    end
    add_index :smoking_records, [:user_id, :smoked_at]
  end
end
