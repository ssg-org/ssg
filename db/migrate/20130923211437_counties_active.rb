class CountiesActive < ActiveRecord::Migration
  def change
    change_table :cities do |t|
      t.boolean :active, :default => true
    end
  end
end
