class SortDate < ActiveRecord::Migration
  def up
  	change_table :issues do |t|
  		t.timestamp :sort_date
  	end
  	Issue.reset_column_information

  	Issue.all.each do |iss| 
  		iss.sort_date = iss.created_at
  		iss.save
  	end
  end

  def down 
  	remove_column :issues, :sort_date
  end
end
