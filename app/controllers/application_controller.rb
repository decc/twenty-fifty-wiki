class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:waiting_for_confirmation,:show,:index,:home,:recent,:changes]
  # before_filter :authenticate_user!, :except => [:waiting_for_confirmation]
  before_filter :dump_format
  
  private

  def dump_format
    request.format ||= :html
    true
  end

  def must_be_administrator
    authenticate_user!
    render(:file => "public/401.html", :status => :unauthorized) unless current_user.administrator?
  end

end
