class ViewPerSession < ActiveRecord::Migration
  def change
    change_table :issues do |t|
    	t.integer :session_view_count,  :default => 0
    end

    create_table	:unique_views do |t|
    	t.integer			:session,	:null => false
    	t.references	:issue, :null => false
    	t.timestamp		:viewed_at

    	t.timestamps
    end

     add_index :unique_views, [:session, :issue_id]
  end
end
