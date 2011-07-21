class PagesController < ApplicationController
  include GenericCrudMethods
  layout :set_layout_from_params

  alias :compiled :show
  
  private
  
  def set_layout_from_params
    params[:layout] || "application"
  end

  def title
   "Index of pages on this wiki"
  end

  def model
   Page
  end

  def parameter_name
   :page
  end

  def resources=(values)
   @pages = values
  end

  def resource=(value)
   @page = value
  end

  def new_resource_with_title(title)
    new_page_url('page[title]' => title)
  end

end
