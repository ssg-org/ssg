class AddStatusToIssues < ActiveRecord::Migration
  def change
  	change_table :issues do |t|
  		t.integer :status, :null => false, :default => 1

  		t.index :status
  	end
  end
end
