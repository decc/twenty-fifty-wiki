class Title < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  before_save :lowercase_title, :set_length
  
  def self.autolink_array
    order('length DESC').all
  end
  
  def self.pages_that_use(*titles)
    titles.compact!
    search = [ Array.new(titles.size,'LOWER(content) LIKE ?').join(" OR "), *titles.map { |t| "%#{t.downcase}%" } ]
    [Page,User,Picture,Category].inject([]) { |results, m| results.concat(m.where(search)) }
  end
  
  def regexp
    @regexp ||= /\b#{Regexp.escape(title)}\b/i
  end
  
  def target_url
    @target_url ||= "/#{target_type.underscore.pluralize.downcase}/#{target_id}"
  end
  
  def similar_titles
    similar_titles = Title.where(:title => self.title).where(['id != ?',self.id])
    return nil if similar_titles.empty?
    similar_titles.map { |t| [t.target_type, t.target_id ] }
  end
  
  def lowercase_title
    return unless self.title
    self.title = self.title.downcase
  end
  
  def set_length
    return unless self.title
    self.length = self.title.length
  end
end
