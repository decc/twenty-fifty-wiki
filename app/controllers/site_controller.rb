class SiteController < ApplicationController
  
  respond_to :html, :xml, :json, :text
  caches_action :index #, :recent
  
  def index
    @title = "Index of all things on this wiki"
    respond_with(@titles = Title.order(:title).all)
  end
  
  def home
    home_page = Page.except(:order).first
    return redirect_to home_page if home_page
    redirect_to new_page_url('page[title]'=>'Home page')
  end
  
  def recent
    @title = "Recent changes to this wiki (#{params[:offset]})"
    @versions = Version.recent.offset(params[:offset].to_i)
  end
  
end
