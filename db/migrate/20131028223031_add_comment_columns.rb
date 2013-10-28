class AddCommentColumns < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.integer  :status_first,  :default => 0
      t.integer  :status_second, :default => 0
    end
  end
end
