class ForgotPasswordTokens < ActiveRecord::Migration
  def up
    create_table :forgot_passwords do |t|
      t.references      :user,           :null => false
      t.string          :token,          :null => false

      t.timestamps
    end
  end

  def down

    drop_table :forgot_passwords

  end
end
