module DeletableExtension
  
  def self.included(base)
    base.instance_eval do
      scope :visible, where(:deleted => nil)
      before_save :update_deleted_flag
    end
  end
  
  # A page is deleted if its only content is the phrase delete or deleted
  def update_deleted_flag
    if content =~ /^delete(d)?\n*$/im # Then this page should be deleted
      return true if deleted? # but don't worry if it is already flagged as such
      self.content = "Deleted\n\n" unless self.content == "Deleted\n\n"
      self.deleted = true
      
      # Remove all the relationships
      autolink_title.destroy if respond_to?(:autolink_title)
      category_memberships.destroy_all if respond_to?(:category_memberships)
      child_category_memberships.destroy_all if respond_to?(:child_category_memberships)
      links_to.destroy_all if respond_to?(:links_to)
      picture.destroy if respond_to?(:picture)
      
      # Alter the title to end with (Deleted on Date Time)
      return true if title =~ /\(Deleted on/ # Don't change the title if it already has a deleted tag
      self.title = self.title + " (Deleted on #{Time.now.to_formatted_s(:long)})"
    else # This page should NOT be flagged as deleted
      self.deleted = nil # Nil rather than false for db lookups.
    end
    true # True so continues with callbacks
  end
  
end
