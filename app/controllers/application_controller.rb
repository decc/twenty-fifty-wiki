class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => 'waiting_for_confirmation'
  before_filter :dump_format
  
  def dump_format
    logger.info request.formats.inspect
    logger.info request.accepts.inspect
    request.format ||= :html
    logger.info request.accepts.inspect
    logger.info request.formats.inspect
    true
  end

end
