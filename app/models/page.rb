class Page < ActiveRecord::Base
  include PreProcessContent
  include DeletableExtension
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff
  include Searchable
  
  default_scope order('LOWER(title) ASC')
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end
  
  # This treats the contents of the page as the index to a book
  def compiled_ast
    return @compiled_ast if @compiled_ast
    @compiled_ast ||= SokclothParser.parse(content)
    # Turn number lists into outlines
    @compiled_ast.walk(:number_list) do |node|
      node.type = :outline
      node.walk(:list_line) do |node|
        page_to_insert = Title.find_by_title(node.join.downcase.strip)
        if page_to_insert
          node.type = :insert_without_increment
          node.replace([node.join.downcase.strip])
        elsif node.first.is_a?(NonTerminalNode)
          node.type = :group
          node.first.type = :heading
          node.first.unshift("0")
        end
      end      
    end
    @compiled_ast
  end
  
  # Inserts include the page title
  def ast_for_insertion
    @ast_for_insertion ||= 
    NonTerminalNode.from_array([:sokcloth,[:heading,'0',title],SokclothParser.parse(content)])
  end
  
  alias :ast_for_latex_insertion :ast_for_insertion
  
  # Summaries include the title, the first paragraph and a link to the full page
  def ast_for_summary
    @ast_for_summary ||=
      NonTerminalNode.from_array([:sokcloth,
        [:heading,'0',title],
        SokclothParser.parse(content).first_matching_node(:paragraph),
        [:paragraph,[:plain_text,"Read more about #{title}."]]
      ])
  end
  
  # Maybe this page should redirect to a different page
  def redirects_to_page
    return @destination_page if @destination_page
    return nil unless content
    title = content[/^See (.*?)\n*$/im,1]
    return nil unless title
    @destination_page = Title.where(:title => title.downcase, :target_type => "Page").first.try(:target)
  end
  
end
