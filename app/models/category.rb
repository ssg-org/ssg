class Category < ActiveRecord::Base
  has_many  :issues
  
  has_many :children, :class_name => "Category", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Category"

  DEFAULT_ICON = 'default.png'
  #
  # Returns true if created, false if edited
  #
  def self.create_or_edit(params)
    require 'pp'
    pp params
    category = (category_id = params[:category_id]).empty? ? Category.new : Category.find(category_id)
    category.name = params[:category_name]
    category.description = params[:description]
    category.parent  = params[:parent_category_id] ? Category.find(params[:parent_category_id]) : nil
    category.color = params[:color]
    category.icon = category.icon || DEFAULT_ICON
    pp '.,...................'
    pp category
    category.save!

    return category_id.empty?
  end
end