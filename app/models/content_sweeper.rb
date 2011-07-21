class ContentSweeper < ActionController::Caching::Sweeper
  observe Page, Category, Picture, User, Cost, CostCategory, CostSource
  
  attr_accessor :original_categories
  attr_accessor :original_title
  
  def after_create(target)
    expire_cache_for(target)
  end

  def before_update(target)
    capture_original_links_to target
  end
    
  def after_commit(target)
    expire_cache_for(target)
  end

  def before_destroy(target)
    capture_original_links_to target
  end

  def after_destroy(target)
    expire_cache_for(target)
  end

  def capture_original_links_to(target)
    self.original_categories = target.categories.to_a
    self.original_title = target.title
  end

  def expire_cache_for(target)
    # If we haven't already set these, set them to empty
    self.original_categories ||= []

    # Figure out where we are trying to expire
    controller = controller_for(target)
    
    # Always expire the recent changes page
    expire_fragment(:controller => 'site', :action => 'recent')
    
    # if the title of the page changed
    if target.title_was_changed
      # Expire the site wide index
      expire_fragment(:controller => 'site', :action => 'index') 
      
      # Expire this page's index
      expire_fragment(:controller => controller, :action => 'index')
      
      Title.pages_that_use(original_title,target.title).each do |model|
        expire_show(model)
      end
    end
    
    # If the content has changed, expire all the category objects as well
    expire_differences(original_categories,target.categories(true))
    
    # Otherwise expire the content pages relevant to that content
    expire_fragment(:controller => controller, :action => 'show', :id => target.id)
  end
  
  def expire_show(target)
    expire_fragment(:controller => controller_for(target), :action => 'show', :id => target.id)
  end
  
  def expire_differences(original_targets,new_targets)
    (original_targets - new_targets).each { |t| p "Expiring #{t.title}"; expire_show(t) }
    (new_targets - original_targets).each { |t| p "Expiring #{t.title}"; expire_show(t) }
  end
  
  def controller_for(target)
    target.class.to_s.underscore.pluralize
  end
end