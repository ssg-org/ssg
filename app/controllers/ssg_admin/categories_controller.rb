# encoding: UTF-8
class SsgAdmin::CategoriesController < SsgAdminController

  before_filter :check_ssg_admin

  def index
    @categories = Category.find(:all).sort() { |a,b| a.name <=> b.name }
    @parent_categories = @categories.select { |c| c.parent.nil? }
    dummy_cat = Category.new(:id => 0, :name => "Glavna Kategorija")
    @parent_categories.unshift(dummy_cat)
  end

  def destroy
    category = Category.find(params[:id])

    unless category.children.size == 0
      children_names = category.children.collect { |c| c.name }
      flash[:alert] = "Kategorija ima pod kategorije '#{children_names.join(',')}', ne možemo obrisati kategoriju."
    else
      number_of_issues = category.issues.size
      unless number_of_issues == 0
        flash[:alert] = "Kategorija ima '#{number_of_issues}' problema vezanih za sebe, ne možemo obrisati kategoriju."
      else
        category.delete!
        flash[:notice] = "Uspješno ste obrisali kategoriju!"
      end
    end

    redirect_to ssg_admin_categories_path()
  end


  # 
  def create_or_edit
    is_created = Category.create_or_edit(params)

    flash[:notice] = "Uspješno ste #{is_created ? 'kreirali' : 'ažurirali'} kategoriju '#{params[:category_name].capitalize}'!"
    redirect_to ssg_admin_categories_path()
  end
end