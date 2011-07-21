module SiteHelper
  def newer_recent_changes_link
    return "" unless params[:offset] && params[:offset].to_i >= 50
    link_to("Newer changes",recent_changes_url(:offset =>  params[:offset].to_i - 50))
  end
  
  def older_recent_changes_link
    return "" if @versions.size < 50
    current_offset = params[:offset].try(:to_i) || 0
    link_to("Older changes",recent_changes_url(:offset => current_offset + 50))
  end
end
