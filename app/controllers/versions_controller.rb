class VersionsController < ApplicationController
  
  cache_sweeper :content_sweeper, :only => [ :revert ]
    
  respond_to :html, :xml, :json, :text
  
  def show
    @version = Version.find(params[:id])
    @target = @version.target
    @versions = @target.versions.recent.offset(params[:offset])
    respond_with(@versions)
  end
  
  def revert
    @version = Version.find(params[:id])
    @target = @version.target
    @version.revert_target_to_this_version
    if @target.save
      flash[:notice] = "#{@version.target_type.downcase} was successfully reverted to version #{params[:id]}" 
      redirect_to @target
    else
      flash[:error] = "Could not revert to the earlier version."
      # FIXME: Must be a more elegant way of doing this
      @page = @user = @picture = @target
      render "#{@version.target_type.downcase.pluralize}/edit"
    end
  end

end
