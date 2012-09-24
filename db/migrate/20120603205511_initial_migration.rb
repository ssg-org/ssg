class InitialMigration < ActiveRecord::Migration
  def up
    create_table  :users do |t|
      t.string  :email
      t.string  :password_hash
      t.string  :fb_id
      t.string  :fb_token
      t.string  :first_name
      t.string  :last_name
      t.boolean :anonymous, :null => false,  :default => false
      t.boolean :active,    :null => false
      t.integer :role,      :null => false

      t.timestamps
    end
    
    add_index :users, [:email, :fb_id, :fb_token]
    
    
    create_table  :issues do |t|
      t.references  :user,      :null => false
      t.references  :category,  :null => false
      t.string      :title,     :null => false
      t.text        :description, :null => false
      t.string      :slug
      
      t.timestamps
    end
    
    add_index :issues, :slug, unique: true
    
    
    create_table  :images do |t|
      t.references  :issue

      t.text      :image
      
      t.timestamps
    end
    
    create_table :comments do |t|
      t.references  :issue, :null => false
      t.references  :user,  :null => false
      t.string      :text,  :null => false
      
      t.timestamps
    end
    
    create_table :categories do |t|
      t.string  :name,        :null => false
      t.text    :description
  	  t.string  :color, :limit => 6, :null => false
      
      t.timestamps
    end
    
    create_table  :votes do |t|
      t.references  :user, :null => false
      t.references  :issue, :null => false
      
      t.timestamp
    end
    
    add_index :votes, [:user_id, :issue_id], :unique => true
    
    create_table  :follows do |t|
      t.references  :user
      
      t.string      :type
      t.integer     :follow_ref_id, :null => false
      
      t.timestamps
    end
    
  end

  def down
    drop_table  :users
    drop_table  :issues
    drop_table  :images
    drop_table  :comments
    drop_table  :categories
  end
end
