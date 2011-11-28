class SiteController < ApplicationController
  
  respond_to :html, :xml, :json, :text
  caches_action :index #, :recent
  
  def index
    @title = "Index of all things on this wiki"
    @titles = Title.order(:title).where("target_type <> 'User'").all # Ever so slightly harder to create a bulk email list
    respond_with(@titles)
  end
  
  def home
    if AppConfig.home_page_id && Page.exists?(AppConfig.home_page_id)
      redirect_to Page.find(AppConfig.home_page_id)
    else
      redirect_to new_page_url('page[title]'=>'Home page')
    end
  end
  
  def recent
    @title = "Recent changes to this wiki (#{params[:offset]})"
    @versions = Version.recent.offset(params[:offset].to_i)
  end
  
end
