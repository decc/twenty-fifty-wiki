require_relative 'sokcloth_parser'

class SokclothToSokcloth
  
  def self.convert(sokcloth)
    ast = SokclothParser.parse(sokcloth)
    html = ast.visit(self.new)
    html
  end
  
  def initialize
    @heading_shift = 1
  end
  
  def sokcloth(*contents)
    visit(contents)
  end
  
  
  def heading(level,*contents)
    "h#{level} #{visit(contents)}\n\n"
  end
  
  def table(*contents)
    @table_cell_sizes = []
    contents.each do |row| 
      row.each_with_index do |cell,index|
        @table_cell_sizes[index] ||= 0
        if cell.first && cell.first.first && cell.first.first.is_a?(String)
          @table_cell_sizes[index] = cell.first.first.size if cell.first.first.size > @table_cell_sizes[index]
        end
      end
    end
    "#{visit(contents)}\n"
  end
  
  def table_row(*contents)
    @cell_index = 0
    "#{visit(contents)}#{extra_cells}|\n"
  end
  
  def extra_cells
    return "" if @cell_index >= @table_cell_sizes.size
    @table_cell_sizes[(@cell_index-1)...-1].map { |size| "| #{" "*size}"}.join('')
  end
  
  def table_cell(*contents)
    @cell_index = @cell_index + 1
    "| #{visit(contents).ljust(@table_cell_sizes[@cell_index-1])} "
  end
  
  def bullet_list(*contents)
    list_structure "*", contents
  end

  def number_list(*contents)
    list_structure "#", contents
  end
  
  def list_structure(type,contents)
    @list_type ||= []
    @list_type << type
    list = visit(contents)
    list << "\n" if @list_type.size == 1
    @list_type.pop
    list
  end
  
  def list_line(*contents)
    if contents.last.is_a?(NonTerminalNode) && [:bullet_list,:number_list].include?(contents.last.type)
      "#{@list_type.last*@list_type.size} #{visit(contents[0...-1])}\n#{contents.last.visit(self)}"
    else
      "#{@list_type.last*@list_type.size} #{visit(contents)}\n"
    end
  end
  
  def paragraph(*contents)
    "#{visit(contents).gsub("\n"," ")}\n\n"
  end
  
  def emphasis(*contents)
    "*#{visit(contents)}*"
  end
  
  def insert(title,page_content = nil)
    "Insert #{title}\n\n"
  end
  
  def summarise(title,page_content = nil)
    "Insert summary of #{title}\n\n"
  end

  def citation(*contents)
    "[#{visit(contents)}]"
  end
  
  def url(*contents)
    visit(contents)
  end
  
  def email(*contents)
    visit(contents)
  end
  
  def matrix(document_id)
    document_id
  end
  
  def category(*categories)
    if categories.size == 1
      "Category: #{categories.first}\n\n"
    else
      "Categories:\n#{categories.join("\n")}\n\n"
    end
  end
  
  def visit(contents)
    contents.map {|c| c.visit(self) }.join
  end
end