class CreateQuitSmokingRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :quit_smoking_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end
  end
end
