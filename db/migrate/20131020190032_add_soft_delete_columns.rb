class AddSoftDeleteColumns < ActiveRecord::Migration
  

  def change
    change_table :users do |t|
      t.boolean   :deleted, :default => false, :required => true
    end

    change_table :categories do |t|
      t.boolean   :deleted, :default => false, :required => true
    end

    change_table :cities do |t|
      t.boolean   :deleted, :default => false, :required => true
    end

  end
end
