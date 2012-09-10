class UploadedFile < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  has_attached_file :attachment, :styles => {}, :convert_options => nil

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
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end
  
  def ast_for_insertion
    @ast_for_insertion ||= new_ast_for_insertion
  end
  
  def new_ast_for_insertion
    NonTerminalNode.from_array [:sokcloth, 
      [:div, "file",
       [:heading,'0', title],
        [:link, 
          attachment.url,
          "#{attachment_file_name} (click to download)"
        ],
        "&nbsp;[#{attachment_content_type} #{number_to_human_size(attachment_file_size)}]",
        SokclothParser.parse(content)
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
      [:link, attachment.url, title]]
  end
  
  # Maybe this page should redirect to a different page
  def redirects_to_page
    nil
  end
end
