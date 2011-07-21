class CategoriesController < ApplicationController
  include GenericCrudMethods
  
  alias :compiled :show
  
  private
  
  def title
    "Index of categories on this wiki"
  end

  def model
    Category
  end
  
  def parameter_name
    :category
  end
 
  def resources=(values)
    @categories = values
  end
  
  def resource=(value)
    @category = value
  end
  
  def new_resource_with_title(title)
    new_category_url('category[title]' => title)
  end
  
end
