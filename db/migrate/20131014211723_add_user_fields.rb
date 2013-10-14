class AddUserFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text   :description
      t.string :website
    end

    change_table :comments do |t|
      t.boolean :admin_comment, :default => false
    end
  end
end
