class AddMoneySavedToQuitSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :quit_smoking_records, :money_saved, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
