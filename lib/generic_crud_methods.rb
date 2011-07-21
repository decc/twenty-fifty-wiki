module GenericCrudMethods
  def self.included(base)
    base.instance_eval do
      respond_to :html, :xml, :json, :text, :pdf, :latex, :tsv
      # caches_action :index, :show, :edit
      cache_sweeper :content_sweeper, :only => [ :create, :update, :destroy ]
    end
  end
  
  def index
     @title = title
     self.resources = values = model.visible
     respond_with(values)
   end

   def show
     self.resource = value = model.find(params[:id])
     if !params[:no_redirect] && value.respond_to?(:redirects_to_page) && value.redirects_to_page
       redirect_to page_url(value.redirects_to_page,:redirect_from => (params[:redirect_from] || value.title))
     else
        respond_with(value)
     end
   rescue ActiveRecord::RecordNotFound
     redirect_to new_resource_with_title(params[:id].gsub('-',' '))
   end
   
   def follow
     value = model.find(params[:id])
     value.follow!
     redirect_to value
   end
   
   def un_follow
     value = model.find(params[:id])
     value.un_follow!
     redirect_to value
   end
   
   def changes
     value = model.find(params[:id])
     redirect_to version_url(value.versions.last)
   end

   def new
     self.resource = value = model.new(params[parameter_name])
     value.set_defaults if value.respond_to?(:set_defaults)
     respond_with(value)
   end

   def edit
     self.resource = value = model.find(params[:id])
     respond_with(value)
   end

   def create
     self.resource = value = model.new(params[parameter_name])
     flash[:notice] = 'Successfully created.' if value.save
     respond_with(value)
   end

   def update
     self.resource = value = model.find(params[:id])
     flash[:notice] = 'Category was successfully updated.' if value.update_attributes(params[parameter_name])
     respond_with(value)
   end

   def destroy
     self.resource = value = model.find(params[:id])
     value.content = "Delete"
     value.save
     respond_with(value)
   end
end
