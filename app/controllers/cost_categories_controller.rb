class CostCategoriesController < ApplicationController
  include GenericCrudMethods
  
  alias :compiled :show

  def help
    render :partial => "help_#{params[:input_id]}"
  end
  
  private
  
  def title
    "Index of cost categories on this wiki"
  end

  def model
    CostCategory
  end
  
  def parameter_name
    :cost_category
  end
 
  def resources=(values)
    @cost_categories = values
  end
  
  def resource=(value)
    @cost_category = value
  end
  
  def new_resource_with_title(title)
    new_cost_category_url('cost_category[label]' => title)
  end
end
