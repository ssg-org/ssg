class AddFacebookToCities < ActiveRecord::Migration
  def change
    add_column :cities, :facebook, :string
  end
end
