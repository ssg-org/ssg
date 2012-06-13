class Category < ActiveRecord::Base
  has_many  :issues
end