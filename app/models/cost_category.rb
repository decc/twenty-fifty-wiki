class CostCategory < ActiveRecord::Base

  before_validation :create_title_from_label
    
  include PreProcessContent
  include DeletableExtension  
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff
  include Searchable
  
  validates_presence_of :label
  
  has_many :costs
  
  def is_a_fuel?
    !default_fuel_unit.blank? && default_capital_unit.blank? && default_operating_unit.blank?
  end
  
  def cost_type
    is_a_fuel? ? :fuel : :technology
  end
  
  def cost_type=(new_cost_type)
    @new_cost_type = new_cost_type
  end
  
  def create_title_from_label
    self.title =[label,"cost data"].compact.join(" ")
  end
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end

  def set_defaults
    self.content = "
What should be included in this category?


What should be excluded from this category?


How are these costs used in the 2050 Pathways model?

Category: Cost data point summaries
"
  self.cost_boilerplate = "
Items that this cost includes


Items that this cost excludes


Detail on the conditions under which this cost is valid


Explanations as to why this cost differs from others


Limitations of this cost estimate

"
  end
  
  %w{ capital_cost_normalised operating_cost_normalised fuel_cost_normalised valid_in_year_normalised valid_for_quantity_of_fuel_normalised }.each do |cost_attribute|
    define_method "#{cost_attribute}_range" do
      ranges = costs.map { |c| c.send(cost_attribute) }
      ranges.flatten!
      ranges.delete_if { |c| c == "?" }
      [ranges.min || "?", ranges.max || "?"]
    end
  end
  
  before_validation :clean_label

  # Strip unwanted bits out of the label
  def clean_label
    return true unless self.label
    self.label = self.label.strip
    true
  end
end
