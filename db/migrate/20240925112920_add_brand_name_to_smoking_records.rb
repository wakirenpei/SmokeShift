class AddBrandNameToSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :smoking_records, :brand_name, :string, null: false
  end
end
