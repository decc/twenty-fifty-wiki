module InsertPageExtension
  
  def process_inserts(ast = self.ast,already_inserted = [self])
    ast.walk(:insert,:insert_without_increment) do |node| # [:insert,"title of page to insert"]
      next if node.size > 1
      page_to_insert = Title.find_by_title(node.first.downcase)
      if page_to_insert
        page_to_insert = page_to_insert.target
        unless already_inserted.include?(page_to_insert)
          insert_ast = process_inserts(page_to_insert.ast_for_insertion, already_inserted + [page_to_insert])
          node << insert_ast
        else
          node << NonTerminalNode.from_array([:sokcloth,[:paragraph,[:plain_text,"#{node.first} has already been inserted"]]])
        end
      end
    end
    ast
  end
    
  def process_latex_inserts(ast = self.ast,already_inserted = [self])
    ast.walk(:insert,:insert_without_increment) do |node| # [:insert,"title of page to insert"]
      next if node.size > 1
      page_to_insert = Title.find_by_title(node.first.downcase)
      if page_to_insert
        page_to_insert = page_to_insert.target
        unless already_inserted.include?(page_to_insert)
          ast = process_latex_inserts(page_to_insert.ast_for_latex_insertion, already_inserted + [page_to_insert])
          node << ast
        else
          node << NonTerminalNode.from_array([:sokcloth,[:paragraph,[:plain_text,"#{node.first} has already been inserted"]]])
        end
      end
    end
  end
end