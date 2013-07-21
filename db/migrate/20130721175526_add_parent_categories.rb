class AddParentCategories < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.integer :parent_id,  :default => nil
    end
  end
end
