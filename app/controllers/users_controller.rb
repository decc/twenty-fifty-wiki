class UsersController < ApplicationController
  include GenericCrudMethods
  
  def waiting_for_confirmation
    @page = Page.find_by_title 'Introduction for new users'
    @user = User.find(params[:id])
  end
  
  private
  
  def title
    "Index of users of this wiki"
  end

  def model
    User
  end
  
  def parameter_name
    :user
  end
 
  def resources=(values)
    @users = values
  end
  
  def resource=(value)
    @user = value
  end
  
  def new_resource_with_title(title)
    users_url
  end
  
end