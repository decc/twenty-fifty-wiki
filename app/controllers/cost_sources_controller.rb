class CostSourcesController < ApplicationController
  include GenericCrudMethods
  
  alias :compiled :show
  
  private
  
  def title
    "Index of cost sources on this wiki"
  end

  def model
    CostSource
  end
  
  def parameter_name
    :cost_source
  end
 
  def resources=(values)
    @cost_sources = values
  end
  
  def resource=(value)
    @cost_source = value
  end
  
  def new_resource_with_title(title)
    new_cost_source_url('cost_source[label]' => title)
  end
end
