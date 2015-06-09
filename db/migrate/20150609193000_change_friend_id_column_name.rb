class ChangeFriendIdColumnName < ActiveRecord::Migration
  def change
    rename_column :friends, :friend_id, :friending_id
  end
end
