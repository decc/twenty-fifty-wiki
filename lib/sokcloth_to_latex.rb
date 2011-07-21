require_relative 'sokcloth_parser'

class SokclothToLatex
  
  def self.convert(sokcloth)
    ast = SokclothParser.parse(sokcloth)
    html = ast.visit(self.new)
    html
  end
  
  def initialize(biggest_heading = nil)
    biggest_heading ||= 'section'
    @names_for_headings = %w{part chapter section subsection subsubsection}
    @heading_shift = @names_for_headings.index(biggest_heading) + 1
  end
  
  def sokcloth(*contents)
    visit(contents)
  end
  
  
  def heading(level,*contents)
    "#{table_of_contents}\\#{latex_for_heading_level(level)}{#{visit(contents)}}\n\n"
  end
  
  def table_of_contents
    return "" if @table_of_contents_done
    @table_of_contents_done = true
    "\\tableofcontents*\n\n"
  end
  
  def latex_for_heading_level(level)
    level = level.to_i+@heading_shift
    @names_for_headings[level-2]
  end
  
  def table(*contents)
    table_columns = []
    contents.each do |row|
      row.each_with_index do |cell,index|
        table_columns[index] ||= (cell =~ /^[\d. ]+$/ ? 'r' : 'l' )
      end
    end
    "\\begin{tabular*}{\\textwidth}{#{table_columns.join(' ')}}\n#{visit(contents)}\\end{tabular*}\n\n"
  end
  
  def table_row(*contents)
    "#{visit(contents," & ")}\\\\\n"
  end
      
  def bullet_list(*contents)
    list_structure "itemize", contents
  end
  
  def number_list(*contents)
    list_structure "enumerate", contents
  end

  def list_structure(type,contents)
    @list_type ||= []
    @list_type << "*"
    list = "\\begin{#{type}}\n"
    list << visit(contents)
    list << "\\end{#{type}}\n"
    list << "\n" if @list_type.size == 1
    @list_type.pop
    list
  end
  
  def list_line(*contents)
    if contents.last.is_a?(NonTerminalNode) && [:bullet_list,:number_list].include?(contents.last.type)
      "\\item #{visit(contents[0...-1])}\n#{contents.last.visit(self)}"
    else
      "\\item #{visit(contents)}\n"
    end    
  end
  
  def paragraph(*contents)
    "#{visit(contents)}\n\n"
  end
  
  def emphasis(*contents)
    "\\emph{#{visit(contents)}}"
  end
  
  def outline(*contents)
    #return visit(contents) if @heading_shift == 1
    return increment_heading_level { visit(contents) }
  end
  
  def insert(title,page_content = nil)
    increment_heading_level { insert_without_increment(title,page_content) }
  end
  
  def insert_without_increment(title,page_content = nil)
    return visit(page_content) if page_content
    "[#{title} to be inserted here]\n\n"  
  end
  
  def summarise(title,page_content = nil)
    return "[summarise #{title} here]\n\n" unless page_content
    page_content.pop # Remove the link at the end
    increment_heading_level { visit(page_content) } 
  end
  
  def increment_heading_level 
    @heading_shift = @heading_shift + 1
    result = yield
    @heading_shift = @heading_shift - 1
    result
  end

  def figure(image_path,title = "",caption = "")
    caption = ""
    latex =<<-END
    \\begin{figure}[h]
    \\caption{#{title}#{caption}}
    \\includegraphics[width=\\columnwidth]{#{image_path}}
    \\end{figure}
    END
  end
  
  def image(image_path)
    "\\includegraphics[width=\\columnwidth]{#{image_path}}"
  end
  
  def figure_number
    @figure_number ||= 0
    @figure_number += 1
  end

  def citation(*contents)
    "\\footnote{#{visit(contents)}}"
  end
  
  def url(*contents)
    "\\url{#{visit(contents)}}"
  end
  
  def email(*contents)
    "\\href{mailto:#{visit(contents)}}{#{visit(contents)}}"
  end
  
  def matrix(document_id)
    target_id = document_id
    "\\href{http://sdcm2w01.dti.local:8265/GetDocument.aspx?number=#{target_id}}{#{document_id}}"
  end
  
  def category(*categories)
    ""
  end
  
  def plain_text(text)
    LatexToPdf.escape_latex(text)
  end
  
  def visit(contents,join = "")
    contents.map do |c|
      if c.is_a?(TerminalNode)
        LatexToPdf.escape_latex(c) 
      else
        c.visit(self)
      end
    end.join(join)
  end
end