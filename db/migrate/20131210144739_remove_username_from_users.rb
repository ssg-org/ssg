class RemoveUsernameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :username
    change_column :users, :email, :string, :null => false, :unique => true
  end

  def down
    add_column :users, :username, :string
    change_column :users, :email, :string, :null => false, :unique => false
  end
end
