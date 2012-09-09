class PicturesController < ApplicationController
  before_filter :must_be_administrator, :only => [:new, :edit, :create, :update]

  include GenericCrudMethods


 # def new
 #   redirect_to root_url
 # end
 # 
 # def edit
 #   redirect_to root_url
 # end
 # 
 # def create
 #   redirect_to root_url
 # end
 # 
 # def update
 #   redirect_to root_url
 # end
 # 
  private
  
  def title
    "Index of pictures on this wiki"
  end

  def model
    Picture
  end
  
  def parameter_name
    :picture
  end
 
  def resources=(values)
    @pictures = values
  end
  
  def resource=(value)
    @picture = value
  end
  
  def new_resource_with_title(title)
    new_picture_url('picture[title]' => title)
  end
  
end
