module CategoryMembershipExtension
  def self.included(base)
    base.instance_eval do
      has_many :category_memberships, :as => :target, :dependent => :destroy
      has_many :categories, :through => :category_memberships, :uniq => true #, :order => 'LENGTH(category_memberships.dependency) ASC'
  
      after_save :update_category_membership_if_changed
    end
  end
  
  # This is used to create forward and back links
  def update_category_membership_if_changed
    return true unless content_was_changed
    return true if deleted?
    update_category_membership
  end
    
  def update_category_membership
    post_process_ast!
    new_category_titles = []
    ast.walk(:category) do |node|
      node.each do |category|
        new_category_titles << category.downcase
      end
   end
   new_category_titles.uniq!
   existing_category_titles = categories.map {|c| c.title.downcase }
   memberships_to_delete = existing_category_titles - new_category_titles
   memberships_to_add = new_category_titles - existing_category_titles
   memberships_to_delete.each do |title| 
     category_memberships.each do |category_membership|
       next unless category_membership.category
       category_membership.destroy if category_membership.category.title.downcase == title
     end
   end
   memberships_to_add.each { |title| create_category_membership(title) }
   true
  end

  def create_category_membership(category_name)
    return true if category_name.strip.size < 3
    title = Title.find_by_title(category_name.downcase)
    category = if title && title.target.is_a?(Category)
      title.target
    else
      Category.create(:title => category_name)
    end
    category_memberships.create!(:category_id => category.id)
  end
end