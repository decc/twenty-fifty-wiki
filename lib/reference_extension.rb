module ReferenceExtension
  
  def process_references(ast = self.ast)
    references = []
    ast.walk(:citation) do |node|
      references << node.dup
      node.replace ["#reference#{references.size}", "[#{references.size}]"]
    end
    return if references.empty?
    ast << NonTerminalNode.from_array([:references,[:number_list, *references.map.with_index do |r,i|
      [:list_line, [:jump_to, "reference#{i+1}"],*r]
    end]])
  end  
end