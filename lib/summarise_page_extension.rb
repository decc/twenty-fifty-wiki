module SummarisePageExtension
  
  def process_summaries(ast = self.ast,already_inserted = [self])
    ast.walk(:summarise) do |node| # [:insert,"title of page to insert"]
      page_to_insert = Title.find_by_title(node.first.downcase)
      if page_to_insert
        page_to_insert = page_to_insert.target
        unless already_inserted.include?(page_to_insert)
          ast = process_summaries(page_to_insert.ast_for_summary, already_inserted + [page_to_insert])
          node << ast
        else
          node << NonTerminalNode.from_array([:sokcloth,[:paragraph,[:plain_text,"#{node.first} has already been summarised"]]])
        end
      end
    end
  end  
end