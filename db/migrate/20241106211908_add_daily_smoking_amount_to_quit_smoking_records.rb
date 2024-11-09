class AddDailySmokingAmountToQuitSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :quit_smoking_records, :daily_smoking_amount, :integer, null: false
  end
end
