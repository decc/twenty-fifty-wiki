module AutolinkExtension
  
  def process_autolinks(ast = self.ast, ignore = [self.title.downcase] )
    autolink_array = Title.autolink_array
    ast.walk(:plain_text) do |node|
      text = node.first
      links = []
      autolink_array.each do |title|
        # next unless title.length
        # next if title.length > text.length
        text.gsub!(title.regexp) do |match|
          if ignore.include?(title.title)
            match
          else
            link = [title.target_url,match]
            link.extend(NonTerminalNode)
            link.type = :link
            links << link
            "%!#{links.size-1}!%"
          end
        end
      end
      node.replace( text.split(/(%!\d+!%)/).map do |element|
        element =~ /%!(\d+)!%/ ? links[$1.to_i] : element
      end)
    end
  end
end