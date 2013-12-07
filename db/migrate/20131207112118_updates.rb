class Updates < ActiveRecord::Migration
  def up
    create_table :updates do |t|
      t.references :user
      t.references :issue

      t.string    :subject
      t.text      :text

      t.timestamps
    end

    add_index :updates, [:user_id, :issue_id]
  end

  def down
    drop_table :updates
  end
end
