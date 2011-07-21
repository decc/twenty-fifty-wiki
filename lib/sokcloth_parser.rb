module NonTerminalNode
  attr_accessor :type
  
  def NonTerminalNode.from_array(ast)
    return ast if ast.is_a?(NonTerminalNode)
    return ast if ast.is_a?(TerminalNode)
    return ast.to_s.extend(TerminalNode) unless ast.is_a?(Array)
    ast.extend(NonTerminalNode)
    ast.type = ast.shift
    ast.replace(ast.map { |e| NonTerminalNode.from_array(e) })
    ast
  end

  def visit(builder = nil)
    return builder.send(type,*self) if builder.respond_to?(type)
    return self.first.visit(builder) if self.size == 1
    self.map { |c| c.visit(builder) }
  end

  def walk(*node_types,&block)
    yield self if node_types.include?(self.type)
    self.each do |node| 
      node.extend(TerminalNode) unless node.respond_to?(:walk)
      node.walk(*node_types,&block)
    end
  end
  
  def first_matching_node(*node_types)
    return self if node_types.include?(self.type)
    self.find do |node|
      node.first_matching_node(*node_types)
    end
  end

  def to_ast
    [type,*self.map(&:to_ast)]
  end

  def inspect; [type,*self].inspect end

  def to_s; self.map(&:to_s).join end
end

module TerminalNode
  
  def walk(*node_types)
    # Do nothing
  end
  
  def first_matching_node(*node_types)
    nil
  end
  
  def visit(builder)
    self
  end
  
  def to_ast
    self
  end
end

module SokclothParser
  
  def self.parse(text)
    DivParser.parse(text)
  end
  
  class GenericElement
    def non_terminal(type,*content)
      content.extend(NonTerminalNode)
      content.type = type
      content.map! do |node|
        case node
        when NonTerminalNode, TerminalNode; node
        when String; node.extend(TerminalNode)
        end
      end
      content
    end
  end
  
  class Heading < GenericElement
    attr_accessor :level
    attr_accessor :text
  
    def initialize(level,text)
      self.level = level
      self.text = text.strip
    end
    
    def to_nodes
      non_terminal :heading, level, text
    end
  end

  class Summary < GenericElement
    attr_accessor :name_of_page_to_summarise
   
    def initialize(name_of_page_to_summarise)
      self.name_of_page_to_summarise = name_of_page_to_summarise.strip
    end
    
    def to_nodes
      non_terminal :summarise, name_of_page_to_summarise
    end
  end

  class Insert < GenericElement
    attr_accessor :name_of_page_to_insert
    
    def initialize(name_of_page_to_insert)
      self.name_of_page_to_insert = name_of_page_to_insert.strip
    end
    
    def to_nodes
      non_terminal :insert, name_of_page_to_insert
    end
    
  end

  class Table < GenericElement
    attr_accessor :lines
    def initialize(first_line)
      self.lines = []
      lines << first_line
    end
  
    def add(line)
      lines << line
    end

    def to_nodes
      non_terminal(:table, *lines.map do |line|
        non_terminal(:table_row, *line.split(/\s*\|\s*/).map do |cell|
          non_terminal :table_cell, *SpanParser.parse(cell.strip).map(&:to_nodes)
        end)
      end)
    end
  end

  class List < GenericElement
    attr_accessor :type
    attr_accessor :level
    attr_accessor :lines
  
    def initialize(markers,text)
      self.type = markers[0]
      self.level = markers.size
      self.lines = [text]
    end
  
    def add(markers,text)
      if (markers.size == self.level) && (markers[0] == self.type) # Continuation of this list
        self.lines << text
      elsif lines.last.is_a?(List) && (markers[0] == lines.last.type) # A continuation of a sub list
          lines.last.add(markers,text)
      else # A new sub list
        lines << List.new(markers,text)
      end
    end
    
    def to_nodes
      non_terminal node_type, *line_nodes
    end
    
    def line_nodes
      nodes = []
      lines.each do |line|
        if line.is_a?(List)
          nodes << non_terminal(:list_line) unless nodes.last
          nodes.last << line.to_nodes
        else 
          nodes <<non_terminal(:list_line, *SpanParser.parse(line).map(&:to_nodes))
        end
      end
      nodes
    end
    
    def node_type
      case type
      when '*'; :bullet_list
      when '#'; :number_list
      end
    end
  end

  class Category < GenericElement
    attr_accessor :categories
    def initialize(category)
      self.categories = [category.strip]
    end
  
    def add_generic_line(category)
      self.categories << category.strip
    end
    
    alias :add :add_generic_line
    
    def to_nodes
      non_terminal :category, *categories.join("; ").split(";").map(&:strip).delete_if { |s| s.size == 0 }
    end
  end

  class Paragraph < GenericElement
    attr_accessor :lines
    def initialize(line)
      self.lines = [line]
    end
  
    def add_generic_line(line)
      self.lines << line
    end
    
    def to_nodes
      non_terminal :paragraph, *SpanParser.parse(lines.join("\n")).map(&:to_nodes)
    end
  end

  class DivParser
    
    def self.parse(text)
      new.parse(text)
    end
  
    attr_accessor :blocks
        
    HEADING =  /^\s*h(\d+)[ .\t]+(.*)/io
    SUMMARY = /^\s*Insert\s+(summary|subcategories|thumbnail)\s+(of|from)\s+(.*)$/io
    INSERT = /^\s*[iI]nsert\s+(.*)$/io
    TABLE = /^\s*\|(.*)$/io
    LIST = /^\s*([\*|#]+)\s*(.*)$/io
    CATEGORY = /^\s*Categor(y|ies):?\s*(.*)/io
    BLANK_LINE = /^\s*$/io
  
    def parse(text)
      self.blocks = []
      process_lines(text)
      blocks.compact!
      blocks.map!(&:to_nodes)
      blocks.extend(NonTerminalNode)
      blocks.type = :sokcloth
      blocks
    end
  
    def process_lines(text)
      return unless text
      text.split(/\n|\r/).each do |line|
        case line
          when HEADING; heading($1,$2)
          when SUMMARY; summary($3)
          when INSERT; insert($1)
          when TABLE; table($1)
          when LIST; list($1,$2)
          when CATEGORY; category($2)
          when BLANK_LINE; blank_line
          else generic(line)
        end
      end
    end
  
    def heading(level,title)
      blocks << Heading.new(level,title)
    end
  
    def summary(page_to_summarise)
      blocks << Summary.new(page_to_summarise)
    end
  
    def insert(page_to_insert)
      blocks << Insert.new(page_to_insert)
    end
  
    def table(line)
      if blocks.last && blocks.last.is_a?(Table)
        blocks.last.add(line)
      else
        blocks << Table.new(line)
      end
    end
  
    def list(marker,line)
      if blocks.last && blocks.last.is_a?(List)
        blocks.last.add(marker,line)
      else
        blocks << List.new(marker,line)
      end
    end
  
    def category(line)
      if blocks.last && blocks.last.is_a?(Category)
        blocks.last.add(line)
      else
        blocks << Category.new(line)
      end
    end
  
    def blank_line
      return unless blocks.last
      return if blocks.last == nil
      blocks << nil
    end
  
    def generic(line)
      if blocks.last.respond_to?(:add_generic_line)
        blocks.last.add_generic_line(line)
      else
        blocks << Paragraph.new(line)
      end
    end
  end

  class Footnote < GenericElement
    attr_accessor :footnote
    
    def initialize(footnote)
      self.footnote = SpanParser.parse(footnote)
    end
    
    def to_nodes
      non_terminal :citation, *footnote.map(&:to_nodes)
    end
  end

  class Emphasis < GenericElement
    
    attr_accessor :text
    
    def initialize(text)
      self.text = WordParser.parse(text)
    end
    
    def to_nodes
      non_terminal :emphasis, *text.map(&:to_nodes)
    end
  end

  class SpanParser < GenericElement
  
    def self.parse(text)
      new.parse(text)
    end
  
    attr_accessor :spans
  
    FOOTNOTE = /(\[.*?\])/io
    EMPHASIS = /(\*.*?\*)/io
  
    def parse(text)
      self.spans = []
      parse_for_footnotes(text)
      spans
    end
  
    def parse_for_footnotes(text)
      text.split(FOOTNOTE).each do |item|
        next if item.empty?
        if item =~ /\[(.*?)\]/io
         spans << Footnote.new($1)
        else
          parse_for_emphasis(item)
        end
      end
    end

    def parse_for_emphasis(text)
      text.split(EMPHASIS).each do |item|
        next if item.empty?
        if item =~ /\*(.*?)\*/io
          spans << Emphasis.new($1)
        else
          spans.concat(WordParser.parse(item))
        end
      end
    end
  end

  class Email < GenericElement
    attr_accessor :address
  
    def initialize(address)
      self.address = address
    end
    
    def to_nodes
      non_terminal :email, address
    end
  end

  class Url < GenericElement
    attr_accessor :href
  
    def initialize(href)
      self.href = href
    end
    
    def to_nodes
      non_terminal :url, href
    end
  end

  class MatrixDoc < GenericElement
    attr_accessor :reference
    def initialize(reference)
      self.reference = reference
    end
    
    def to_nodes
      non_terminal :matrix, reference
    end
  end

  class PlainText < GenericElement
    attr_accessor :words
  
    def initialize(word)
      self.words = [word]
    end
  
    def add(word)
      self.words << word
    end
    
    def to_nodes
      non_terminal :plain_text, words.join
    end
  end
  
  class WordParser < GenericElement

    attr_accessor :spans
  
    def self.parse(text)
      new.parse(text)
    end
  
    EMAIL = /([A-Za-z0-9.-]+?@[A-Za-z0-9.-]*[A-Za-z])/io
    URL = /((http(s?):|www\.)\S*\w\/?)/io
    MATRIX_DOC =  /(D\d+\/\d+)/io
  
    def parse(text)
      self.spans = []
      text.split(/(\s+)/).each do |word|
        case word
        when EMAIL;       add($`,Email.new($1),$')
        when URL;         add($`,Url.new($1),$')
        when MATRIX_DOC;  add($`,MatrixDoc.new($1),$')
        else add_plain_text(word)
        end
      end
      spans
    end 
  
    def add(before,during,after)
      add_plain_text(before) if before && before.size > 0
      spans << during
      add_plain_text(after) if after && after.size > 0
    end
  
    def add_plain_text(word)
      if spans.last.is_a?(PlainText)
        spans.last.add(word)
      else
        spans << PlainText.new(word)
      end
    end
  end
end
