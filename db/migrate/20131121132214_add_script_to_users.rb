class AddScriptToUsers < ActiveRecord::Migration
  def change
    add_column :users, :script, :string
  end
end
