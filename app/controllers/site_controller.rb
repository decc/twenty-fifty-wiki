class SiteController < ApplicationController
  
  respond_to :html, :xml, :json, :text
  caches_action :index #, :recent
  
  def index
    @title = "Index of all things on this wiki"
    respond_with(@titles = Title.order(:title).all)
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
