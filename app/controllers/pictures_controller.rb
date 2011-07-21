class PicturesController < ApplicationController
  include GenericCrudMethods
  
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
