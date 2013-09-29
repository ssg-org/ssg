class NewFieldsForCity < ActiveRecord::Migration
  def change
    change_table :cities do |t|
      t.string       :website, :required => false
      t.text         :description
      t.references   :image
    end
  end
end
