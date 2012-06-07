class AddTimestampColumnsToFbItems < ActiveRecord::Migration
  def up
  	add_column :fb_items, :fb_created_at, :datetime
    add_column :fb_items, :fb_updated_at, :datetime
  end
  
  def down
  	remove_column :fb_items, :fb_created_at
    remove_column :fb_items, :fb_updated_at
  end
end
