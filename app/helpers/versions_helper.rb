module VersionsHelper
  
  def page_newer_changes_link
    return "" unless params[:offset] && params[:offset].to_i >= 49
    link_to("Newer changes",version_url(@versions.first,:offset => params[:offset].to_i - 49)) 
  end
  
  def page_older_changes_link
    return "" if @versions.size < 50
    current_offset = params[:offset].try(:to_i) || 0
    link_to("Older changes",version_url(@versions.last,:offset => current_offset + 49))    
  end  
end
