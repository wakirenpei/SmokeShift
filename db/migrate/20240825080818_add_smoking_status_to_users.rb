class AddSmokingStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :smoking_status, :integer, default: 0, null: false
  end
end
