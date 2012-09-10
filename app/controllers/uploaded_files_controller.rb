class UploadedFilesController < ApplicationController

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
    "Index of files that have been uploaded to this wiki"
  end

  def model
    UploadedFile
  end
  
  def parameter_name
    :uploaded_file
  end
 
  def resources=(values)
    @uploaded_files = values
  end
  
  def resource=(value)
    @uploaded_file = value
  end
  
  def new_resource_with_title(title)
    new_file_url('uploaded_file[title]' => title)
  end
  
end
