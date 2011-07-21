module Sokcloth
  include InsertPageExtension
  include SummarisePageExtension
  include AutolinkExtension
  include ReferenceExtension
  
  def post_process_ast!
    return if @post_process_complete
    process_inserts
    process_summaries
    process_references
    process_autolinks
    @post_process_complete = true
  end
  
  def to_html
    return @html if @html
    post_process_ast! 
    @html = ast.visit(SokclothToHtml.new)
  end
  
  def to_latex
    return @latex if @latex
    process_latex_inserts
    process_summaries
    @latex = ast.visit(SokclothToLatex.new)
  end
  
  def compiled_ast
    @compiled_ast ||= SokclothParser.parse(compiled_content)
  end
  
  def to_compiled_html
    return @compiled_html if @compiled_html
    process_inserts(compiled_ast)
    process_summaries(compiled_ast)
    process_references(compiled_ast)
    process_autolinks(compiled_ast)
    @compiled_html = compiled_ast.visit(SokclothToHtml.new)
  end
  
  def to_compiled_latex(biggest_heading = 'section')
    return @compiled_latex if @compiled_latex
    process_latex_inserts(compiled_ast)
    process_summaries(compiled_ast)
    @compiled_latex = compiled_ast.visit(SokclothToLatex.new(biggest_heading))
  end
  
  def to_text
    "h1 #{title}\n\n#{content}"
  end
  
  def as_json(options={})    
    ast.to_ast.as_json
  end
end