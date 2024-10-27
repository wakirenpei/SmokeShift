class CreateSavingsGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :savings_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quit_smoking_record, null: false, foreign_key: true
      t.integer :target_amount, null: false
      t.date :start_date, null: false
      t.datetime :achieved_at
      t.integer :status, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :savings_goals, [:user_id, :deleted_at, :status]
  end
end
