class SearchController < ApplicationController
  
  auto_complete_for :page, :title
  
  respond_to :html, :xml, :json, :text
  
  def index
    if title = Title.find_by_title(params[:search].try(:downcase))
      return redirect_to(title.target)
    else
      @title = params[:search] ? "Results of search for '#{params[:search]}'" : "Search the DECC Wiki"
      if params[:search] && !params[:search].empty? 
        @search = Sunspot.search(Page,User,Picture,Category,Cost,CostCategory,CostSource) do
          keywords(params[:search]) do
            highlight :content
          end
          paginate :page => params[:page]
        end
      end
    end
  end


end
