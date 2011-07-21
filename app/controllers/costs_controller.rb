class CostsController < ApplicationController
  include GenericCrudMethods
  
  alias :compiled :show
  
  def new
    @cost = params[:cost_to_clone] && Cost.find(params[:cost_to_clone]).try(:clone_to_new_cost)
    @cost ||= Cost.new
    @cost.cost_category_id ||= params[:cost_category_id]
    @cost.cost_source_id ||= params[:cost_source_id]
    @cost.set_defaults if @cost.respond_to?(:set_defaults)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cost }
    end
  end
  
  def help
    render :partial => "help_#{params[:input_id]}"
  end
  
  def create
    self.resource = value = model.new(params[parameter_name])
    flash[:notice] = 'Successfully created.' if value.save
    if value.new_cost_source_created?
      redirect_to edit_cost_source_url(value.cost_source)
    else
      respond_with(value)
    end
  end

  def update
    self.resource = value = model.find(params[:id])
    flash[:notice] = 'Category was successfully updated.' if value.update_attributes(params[parameter_name])
    if value.new_cost_source_created?
      redirect_to edit_cost_source_url(value.cost_source)
    else
      respond_with(value)
    end
  end 
  
  def bulk
    if params[:tsv] && params[:tsv].starts_with?("class\tCost")
      tsv = params[:tsv].gsub(/class\tCost.*?\r\n/i,"class\tCost\r\n")
      require 'csv'
      @uploaded_costs = CSV.load(tsv,:col_sep => "\t")
    else
      flash[:error] = "Only cost data can be bulk uploaded"
    end
    render :bulk_update
  end
  
  private
  
  def title
    "Index of costs on this wiki"
  end

  def model
    Cost
  end
  
  def parameter_name
    :cost
  end
 
  def resources=(values)
    @costs = values
  end
  
  def resource=(value)
    @cost = value
  end
  
  def new_resource_with_title(title)
    new_cost_url('cost[label]' => title)
  end
end
