class InitialMigration < ActiveRecord::Migration
  def up
    
    create_table  :areas do |t|
      t.string  :country
      t.string  :city
      t.string  :postal_code
      t.string  :community
      t.integer :latitude
      t.integer :longitude
    end
    
    create_table  :users do |t|
      t.string  :email,         :null => false
      t.string  :password_hash
      t.string  :fb_id
      t.string  :fb_token
      t.string  :first_name
      t.string  :last_name
      t.string  :address
      t.string  :phone
      t.boolean :anonymouse,  :null => false,  :default => false
      t.boolean :active,      :null => false
      t.integer :role,        :null => false
    end
    
    add_index :users, [:email, :fb_id, :fb_token]
    
    create_table  :issues do |t|
      t.string  :description
      t.decimal :latitude
      t.decimal :longitude
      t.integer :no_views
      t.integer :no_ups
      t.integer :no_downs
      
      t.references  :user
      t.references  :areas
      
      t.timestamps
    end
  end

  def down
    drop_table  :issues
    drop_table  :users
    drop_table  :areas
  end
end
