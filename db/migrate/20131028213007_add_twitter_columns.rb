class AddTwitterColumns < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string  :twitter_id
      t.string  :twitter_token
    end
  end
end
