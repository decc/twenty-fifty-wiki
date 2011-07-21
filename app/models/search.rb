class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?; false end

  attr_accessor :term, :offset, :limit
  
  def initialize(params = nil)
    params ||= {}
    self.term = params['term'] || ""
    self.term.strip!
    self.offset = params['offset'] || 0
    self.limit = params['limit'] || 20
  end
    
  def exact_match
    return false if self.term.empty?
    Title.find_by_title(self.term.downcase)
  end
  
  def titles
    return [] if self.term.empty?
    Title.where(['title LIKE ?',"%#{self.term.downcase}%"]).limit(self.limit).offset(self.offset).map(&:target)
  end
  
  def content
    return [] if self.term.empty?
    Page.where(['LOWER(content) LIKE ?',"%#{self.term.downcase}%"]).limit(self.limit).offset(self.offset) + 
    User.where(['LOWER(content) LIKE ?',"%#{self.term.downcase}%"]).limit(self.limit).offset(self.offset)
  end
  
end
