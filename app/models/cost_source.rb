class CostSource < ActiveRecord::Base
  
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

  has_many :costs, :dependent => :destroy

  def create_title_from_label
    self.title =[label,"cost source"].compact.join(" ")
  end
  
  def set_defaults
    self.content = "
h1 How do you find this source?


h1 What is the general approach that this source takes to estimating costs?


h1 What are the limitations of this source?

Category: Cost sources
  "
  end  
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end

  before_validation :clean_label

  # Strip unwanted bits out of the label
  def clean_label
    return true unless self.label
    self.label = self.label.strip
    true
  end

end
