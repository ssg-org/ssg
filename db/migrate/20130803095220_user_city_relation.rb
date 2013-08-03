class UserCityRelation < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :username, :null => false
      t.references :city,  :default => nil
    end
  end

end
