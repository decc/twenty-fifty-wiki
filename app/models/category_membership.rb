class CategoryMembership < ActiveRecord::Base
  belongs_to :category
  belongs_to :target, :polymorphic => true
  
  after_create :cascade_memberships
  after_destroy :destroy_dependent_relationships
  
  validate :does_not_create_infinte_loops
  
  def does_not_create_infinte_loops
    return unless direct?
    errors.add_to_base "Please don't add a #{category.title} to itself" if self_referential?
    errors.add_to_base "Adding '#{target.title}' (#{target.id}) to '#{category.title}'(#{category.id}) would create a circular loop" if circular?
  end
  
  def cascade_memberships
    return true unless direct?
    add_self_to_parents_of_parent
    return true unless target_type == "Category"
    add_category_target_children
    true # Permit other callbacks to occur
  end
    
  def destroy_dependent_relationships
    CategoryMembership.delete_all "dependency LIKE '% #{id} %'"
    true # Permit other callbacks to occur
  end

  def to_dependency_string
    direct? ? "#{dependency} #{id}" : "#{dependency}"
  end  

  def to_s
    "t#{id}: #{category.id} -> #{target.id} depends_on: #{dependency}"
  end
  
  def add_self_to_parents_of_parent
    parents_of_parent.each do |parent_membership|
      create_membership  parent_membership.category, target, parent_membership
    end
  end

  def parents_of_parent
    @parents_of_parent ||= CategoryMembership.where(:target_type => 'Category').where(:target_id => category_id)
  end
  
  def add_category_target_children
    target_child_category_memberships.each do |child_membership|
      target.category_memberships.each do |category_membership|
        create_membership category_membership.category, child_membership.target, child_membership, category_membership
      end
    end
  end
    
  def target_child_category_memberships
    @target_children ||= CategoryMembership.where(:category_id => target_id)
  end
  
  # Is a direct entry if not added by any other list
  def direct?
   !dependency
  end

  # Because had problems pattern matching on some sql versions
  # Surround the dependency field with spaces and fullstops like . so .
  def dependency=(value)
   self[:dependency] = ". #{value} .".gsub(/ +/,' ')
  end

  def dependency
   return nil unless self[:dependency]
   self[:dependency][%r{^\. (.*) \.$},1]
  end

  def create_membership(category,target,*dependent_memberships)
   dependency = dependent_memberships.map {|link| link.to_dependency_string }.join(' ') + " #{id}"
   CategoryMembership.create :category => category, :target => target, :dependency => dependency    
  end

  def self_referential?
    return false unless target_type == "Category"
    category_id == target_id
  end

  def circular?
    return false unless target_type == "Category"
    CategoryMembership.where(:category_id => target_id).where(:target_type => "Category").where(:target_id => category_id).count > 0
  end
end
