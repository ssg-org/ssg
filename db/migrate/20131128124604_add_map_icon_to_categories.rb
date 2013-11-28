class AddMapIconToCategories < ActiveRecord::Migration
	class Category < ActiveRecord::Base
	end

  def up
    add_column :categories, :map_icon, :string

    change_column :categories, :icon, :string, :null => true
  
    Category.reset_column_information

    Category.all.each do |category|
    	category.map_icon = category.icon
    	category.icon = nil
    	category.save!
    end
  end

  def down
  	remove_column :categories, :map_icon
  	change_column :categories, :icon, :string, :null => false
  end
end
