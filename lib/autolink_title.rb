module AutolinkTitle
  
  def self.included(base)
    base.instance_eval do
      # The title
      has_one :autolink_title, :as => :target, :class_name => 'Title', :dependent => :destroy
      validates_length_of :title, :minimum => 3, :maximum => 255
      validates_uniqueness_of :title, :case_sensitive => false
      
      # Forward and back links
      has_many :links_to, :as => :from, :class_name => 'Link', :dependent => :destroy
      has_many :linked_to_from, :as => :to, :class_name => 'Link', :dependent => :destroy

      %w{pages pictures categories users costs cost_sources cost_categories}.each do |type|
        has_many "links_to_#{type}", :through => :links_to, :source => :to, :source_type => type.classify
        has_many "linked_to_from_#{type}", :through => :linked_to_from, :source => :from, :source_type => type.classify
      end

      before_validation :clean_title
      
      after_save  :update_autolink_title
      after_save  :update_links_to_if_changed
      after_save  :update_links_from
    end
  end
  
  # Strip unwanted bits out of the normal title
  def clean_title
    return true unless self.title
    self.title = self.title.strip
    self.title = self.title.gsub("\r",' ')
    self.title = self.title.gsub("\n",' ')
    self.title = self.title.gsub("\t",' ')
    self.title = self.title.gsub(/ +/,' ')
    true
  end
  
  def linked_to_from_all
    linked_to_from_pages + linked_to_from_pictures + linked_to_from_categories + linked_to_from_users
  end
  
  # This is used in the autolinking
  def update_autolink_title
    return true unless title_was_changed
    return true if deleted?
    if self.autolink_title
      self.autolink_title.update_attribute(:title,self.title)
    else
      self.autolink_title = Title.create(:title => self.title)
    end
    true
  end
  
  # This is used to create forward and back links
  def update_links_to_if_changed
    return true unless content_was_changed
    update_links_to
  end
  
  def update_links_to
    return true if deleted?
    post_process_ast!
    new_link_titles = []
    ast.walk(:link,:insert,:summarise) do |node|
      new_link_titles << ((node.type == :link) ? node.last.downcase : node.first.downcase)
    end
    new_link_titles.uniq!
    existing_link_titles = links_to.map { |link| link.to.title.downcase }
    links_to_delete = existing_link_titles - new_link_titles
    links_to_add = new_link_titles - existing_link_titles
    links_to_delete.each do |title| 
      links_to.each do |link|
        link.destroy if link.to.title.downcase == title
      end
    end
    links_to_add.each { |title| new_link_to(title) }
    true
  end
  
  def new_link_to(title)
    title = Title.find_by_title(title.downcase)
    return nil unless title
    links_to.create!(:to_type => title.target_type,:to_id => title.target_id)
  end
  
  def update_links_from
    return true unless title_was_changed
    Delayed::Job.enqueue UpdateTitles.new(title_was, title)
    true
  end
  
end
