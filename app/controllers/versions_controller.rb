class VersionsController < ApplicationController
  
  cache_sweeper :content_sweeper, :only => [ :revert ]
    
  respond_to :html, :xml, :json, :text
  
  def show
    @version = Version.find(params[:id])
    @target = @version.target
    @versions = @target.versions.recent.offset(params[:offset])
    if params[:comparison_id] 
      if params[:comparison_id] == "nill"
        @previous_version = nil
      else
        @previous_version = Version.find(params[:comparison_id])
        if @previous_version == @version.previous_version
          @message = "Showing just the changes made in the edit by #{@version.user.try(:name)} at #{@version.created_at}"
        else
          @message = "Showing all changes since #{@previous_version.created_at}"
        end
      end
    else
      if @version.user == User.current
        @previous_version = @version.previous_version
        @previous_version = @previous_version.previous_version while @previous_version.user == User.current
        @message = "Showing all changes since you started editing this page."
      else
        @previous_version = @versions.find { |v| v.user == User.current }
        if @previous_version
          @message = "Showing all changes since you last edited this page on #{@previous_version.created_at}"
        end
      end
    end
    unless @previous_version
      @previous_version = @version.previous_version
      @message = "Showing just the changes made in the edit by #{@version.user.try(:name)} at #{@version.created_at}"
    end
    call_for_evidence_time = Time.local(2011,8,10)
    @call_for_evidence_version = @versions.find { |v|  v.created_at < call_for_evidence_time }
    @showing_previous_version = (@previous_version == @version.previous_version)
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
