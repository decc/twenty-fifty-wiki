class Picture < ActiveRecord::Base

  has_attached_file :picture
  before_save :update_picture_dimensions

  include PreProcessContent
  include DeletableExtension  
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff  
  include Searchable
  
  # Validations
  validates_uniqueness_of :title, :case_sensitive => false
  
  
  def update_picture_dimensions
    return true if deleted?
    return true unless picture && picture.queued_for_write[:medium]
    geometry = Paperclip::Geometry.from_file(picture.queued_for_write[:medium].path)
    self.medium_picture_width = geometry.width
    self.medium_picture_height = geometry.height
    true # continue
  end
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end
  
  def ast_for_insertion
    @ast_for_insertion ||= new_ast_for_insertion
  end
  
  def new_ast_for_insertion
    NonTerminalNode.from_array [:sokcloth, 
      [:figure, 
        picture.url(:medium), 
        title,
        SokclothParser.parse(content).first_matching_node(:paragraph),
        "/pictures/#{id}",
        medium_picture_width,
        medium_picture_height
      ]
    ]
  end
  
  def ast_for_latex_insertion
    NonTerminalNode.from_array [:sokcloth, 
      [:figure, picture.path, title, SokclothParser.parse(content).first_matching_node(:paragraph) ]
    ]
  end
  
  def ast_for_summary
    @ast_for_summary ||= 
    NonTerminalNode.from_array [:sokcloth, 
      [:image, picture.url(:thumb), "/pictures/#{id}"]]
  end
  
  # Maybe this page should redirect to a different page
  def redirects_to_page
    nil
  end
end
