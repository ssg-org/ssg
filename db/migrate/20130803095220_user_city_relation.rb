class UserCityRelation < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :username
      t.references :city
    end
  end

end
