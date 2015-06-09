class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :friendships, :friending_id, :user_id
    rename_column :friendships, :friended_id, :friend_id
  end
end
