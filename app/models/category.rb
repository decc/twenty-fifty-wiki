class Category < ActiveRecord::Base
  include PreProcessContent
  include DeletableExtension  
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff
  include Searchable
  
  has_many :child_category_memberships, :class_name => 'CategoryMembership', :foreign_key => :category_id, :dependent => :destroy
  
  has_many :child_categories, :through => :child_category_memberships, :source => :target, :source_type => 'Category', :conditions => 'dependency IS null', :order => 'categories.title ASC'
  has_many :parent_categories, :through => :category_memberships, :source => :category, :conditions => 'dependency IS null'
    
  # Validations
  validates_uniqueness_of :title, :case_sensitive => false
    
  def ast
    @ast ||= SokclothParser.parse(content)
  end

  def compiled_content
    @compiled_content ||= "#{content}\n" + child_category_memberships.map(&:target).uniq.map { |target| "insert #{target.title}" }.join("\n")
  end
    
  def ast_for_insertion
     @ast_for_insertion ||= 
      NonTerminalNode.from_array( [:sokcloth,
        [:heading,'0',title],
        SokclothParser.parse(content),
        [:bullet_list,
          *child_category_memberships.map(&:target).uniq.map { |target| [:bullet_line,[:plain_text,target.title]] }
        ]
      ])
  end
  
  alias :ast_for_latex_insertion :ast_for_insertion
  
  def ast_for_summary
    @ast_for_summary ||= 
     NonTerminalNode.from_array( [:sokcloth,
       [:heading,'0',title],
       [:bullet_list,
         *child_categories.map { |category| [:bullet_line,[:plain_text,category.title]] }
       ]
     ]) 
  end
    
  # Maybe this page should redirect to a different page
  def redirects_to_page
    nil
  end
  
end
