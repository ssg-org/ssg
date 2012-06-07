class InitialMigration < ActiveRecord::Migration
  def up
    
    create_table  :areas do |t|
      t.string  :country
      t.string  :city
      t.string  :postal_code
      t.string  :community
      t.decimal :latitude
      t.decimal :longitude
    end
    
    create_table  :users do |t|
      t.string  :email
      t.string  :password_hash
      t.string  :fb_id
      t.string  :fb_token
      t.string  :first_name
      t.string  :last_name
      t.string  :address
      t.string  :phone
      t.string  :locale
      t.string  :gender
      t.boolean :anonymous, :null => false,  :default => false
      t.boolean :active,    :null => false
      t.integer :role,      :null => false
    end
    
    add_index :users, [:email, :fb_id, :fb_token]
    
    create_table  :issues do |t|
      t.string  :name,        :null => false
      t.string  :description
      t.decimal :latitude
      t.decimal :longitude
      t.integer :no_views,    :default => 0
      t.integer :no_ups,      :default => 0
      t.integer :no_downs,    :default => 0
      
      t.references  :user
      t.references  :area
      
      t.timestamps
    end

    create_table :issue_updates do |t|
      t.string  :description,  :null => false
      t.boolean :anonymous,    :null => false, :default => false      

      t.references :issue
      t.references :user

      t.timestamps
    end

    create_table :attachments do |t|
      t.string  :name,       :null => false
      t.string  :file_name
      t.string  :file_type      
      t.string  :URL
      t.integer :size
      t.integer :width
      t.integer :height

      t.timestamps

      t.references :user
      t.references :issue      
    end

    create_table :fb_items do |t|
      t.integer :fb_id, :null => false
      t.string  :fb_object_type
      t.integer :ssg_id, :null => false
      t.string  :name

      t.timestamps
    end

    add_index :fb_items, [:fb_id, :ssg_id]
  end

  def down
    drop_table  :fb_items
    drop_table  :attachments
    drop_table  :issue_updates
    drop_table  :issues
    drop_table  :users
    drop_table  :areas
  end
end
