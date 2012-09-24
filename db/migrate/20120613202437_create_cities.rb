class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name,	:null => false
      t.string      :slug
      t.decimal     :lat
      t.decimal     :long

      t.timestamps
    end

    change_table :issues do |t|
    	t.references				:city, :default => 1, :null => false 
    end

    change_column	:issues, :city_id, :integer, :default => :null 

  end
end
