module Versioned
  def self.included(base)
    base.instance_eval do
      # Relationships
      belongs_to :user # The user who last updated the page
      has_many :versions, :as => :target, :dependent => :destroy # This and previous versions of the page
      
      # Validation
      before_validation :check_for_conflicts
      validate :no_conflicts

      # Callbacks
      before_save :set_user
      after_save  :create_version
    end
  end
  
  def no_conflicts
    errors.add(:base, "Sorry, someone else edited this page while you were editing it, and changed some text in an area near to where you edited. Please take a look at their changes (marked below) and merge them with yours") if @conflicts
  end
  
  def check_for_conflicts
    p versions.last, @previous_version_id, versions.last.try(:id), @previous_version_id
    if versions.last && @previous_version_id && versions.last.id != @previous_version_id
      ancestor = versions.find(@previous_version_id)
      p self.content, ancestor.content, self.content_was
      d = Diff3.new(self.content,ancestor.content,self.content_was)
      self.content = d.merged_text
      @conflicts = d.conflict?
    else
      @conflicts = false
    end
    true # Callbacks continue
  end
  
  def previous_version_id
    versions.last.try(:id)
  end
  
  def previous_version_id=(old_id)
    @previous_version_id = old_id
  end
  
  def set_user
    if User.current
      self.user = User.current
    elsif self.is_a?(User)
      self.user = self
    end
    true
  end
  
  def title_was_changed
    changed.include?('title')
  end
  
  def content_was_changed
    changed.include?('content')
  end

  def create_version
    return true unless versioned_attributes_have_changed?
    follow! if self.respond_to?(:follow!)
    Version.create_from(self)
    true
  end
  
  def versioned_attributes_have_changed?
    Version.versioned_attributes.any? { |attr| changed.include?(attr.to_s) }
  end
end