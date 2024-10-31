class ChangeStartDateTypeInSavingsGoals < ActiveRecord::Migration[7.1]
  def change
    change_column :savings_goals, :start_date, :datetime
  end
end
