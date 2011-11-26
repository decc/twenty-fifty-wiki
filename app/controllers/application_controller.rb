class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:waiting_for_confirmation,:show,:index,:home,:recent,:changes]
  before_filter :dump_format
  
  def dump_format
    request.format ||= :html
    true
  end

end
