class AgregatedVotesViews < ActiveRecord::Migration
  def change
    change_table :issues do |t|
    	t.integer :vote_count,  :default => 0
    	t.integer :view_count,  :default => 0
    	t.integer :comment_count,  :default => 0
    end
  end

end
