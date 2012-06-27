class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email, :null => false

      t.timestamps
    end

    add_index :invites, :email
  end
end
