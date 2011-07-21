module PreProcessContent
  def self.included(base)
    base.instance_eval do
      before_validation :pre_process_content
    end
  end
  
  def pre_process_content
    return true unless content
    return true unless content_changed?
    self.content = SokclothToSokcloth.convert(CopyPasteRewrite.rewrite(self.content))
    true
  end
end

class CopyPasteRewrite
  def self.rewrite(text)
    CopyPasteRewrite.new(text).rewrite
  end
  
  attr_accessor :text
  
  def initialize(text)
    self.text = text
  end
  
  def rewrite
    rewrite_newlines
    rewrite_tables
    rewrite_bullets
    text
  end
  
  def rewrite_newlines
    text.gsub!(/\r/,'')
  end
  
  def rewrite_tables
    text.gsub!(/^(([^\t\n]+\t)+)([^\t\n]*$)/) do
      cells = $1.split("\t")
      cells << $3 if $3
      "| #{cells.map(&:strip).join(" | ")} |"
    end
  end
  
  def rewrite_bullets
    text.gsub!(/^(\t+)\u2022\s*/) { ("*"*($1.size+1)) + " " }
    text.gsub!(/^\s*\u2022\s*/,"* ")
  end
end
    
      