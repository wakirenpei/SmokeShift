class RemoveMoneySavedFromQuitSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    remove_column :quit_smoking_records, :money_saved, :decimal
  end
end
