# encoding: utf-8
class ConvertHtmlToSokcloth

  attr_accessor :html
  
  def initialize(html)
    self.html = html
  end
  
  def convert
    convertor_methods = methods.find_all { |m| m =~ /\d+$/ }
    convertor_methods = convertor_methods.sort_by { |m| m[/(\d+)$/,1].to_i }
    write
    convertor_methods.each do |m|
      puts "#{@counter}) #{m}"
      self.send(m)
      write
    end
  end
  
  def replace_nsbps_0
    html.gsub!('&nbsp;',' ')
    html.gsub!('&amp;',' and ')
  end
  
  def remove_unwanted_blocks_1
    %w{head}.each do |block_tag|
      html.gsub!(/<#{block_tag}.*?<\/#{block_tag}>/mi,'')
    end
  end
  
  def remove_unwanted_tags_2
    %w{meta span br body html sup}.each do |block_tag|
      html.gsub!(/<\/?#{block_tag}.*?\/?>/mi,'')
    end
  end
  
  def remove_table_of_contents_3
    html.gsub!(/<p class=MsoToc(\d+|Heading).*?<\/p>/mi,'')
  end
  
  def remove_sections_4
    html.gsub!(/<div class=WordSection\d+>/im,'')
  end
  
  def remove_ole_links_5
    html.gsub!(/<a[ \n\t]+name="OLE.*?>/im,'')
  end
  
  def replace_headings_9
    html.gsub!(/<h(\d+).*?>(.*?)<\/h\d+>/im) do |m|
      if $2.strip.size == 0
        ""
      else
        level = $1
        heading = $2.gsub(/<\/?.*?\/?>/im,'')
        heading.gsub!(/^\d+[a-z]*\./,'')
        heading.gsub!("\n"," ")
        heading.strip!
        "h#{level} #{heading}\n\n"
      end
    end
  end
  
  def replace_normal_paragraphs_10
    html.gsub!(/<p.*?>(.*?)<\/p>/mi) do |m|
      $1.gsub("\n"," ") + "\n\n"
    end
  end
    
  def create_bullet_lists_12
    html.gsub!(/\n· +/i,"* ")
    html.gsub!(/\no +/i,"* ")
    html.gsub!(/\n- +/i,"* ")    
  end
  
  def create_bullet_lists_from_uls_13
    html.gsub!(/<ul.*?>(.*?)<\/ul>/im) do
      $1.gsub!(/ *<li.*?>(.*?)<\/li>/im) do
        "* "+$1.strip.gsub("\n"," ") + "\n"
      end
    end
  end
    
  def remove_spacing_between_bullet_lists_14
    html.gsub!(/\n\* *([^\n]*)\n\s*(?=\n\*)/m) do |m|
      "\n* #{$1}"
    end
  end
  
  def replace_images_16
    html.gsub!(/<img .*?src="(.*?)".*?>/im) do |m|
       "\n\ninsert picture #{File.basename($1,'.*')}\n\n"
    end
  end
  
  def replace_tables_17
    html.gsub!(/<table.*?>(.*?)<\/table>/im) do
      "\n\n" + $1.gsub("\n"," ") + "\n\n"
    end
    html.gsub!(/<tr.*?>/im,"| ")
    html.gsub!(/<thead.*?>/im,"| ")
    html.gsub!(/<td.*?>(.*?)<\/td>/im) do
      $1.strip.gsub(/ +/," ").gsub(/h\d /i,'') + " |"
    end
    html.gsub!(/<\/tr.*?>/im,"\n")
    html.gsub!(/<\/thead.*?>/im,"\n")
    html.gsub!(/\n +\| +/im,"\n| ")
  end
  
  def replace_footnotes_18
    html.gsub!(/<a href="#_ftn(\d+)".*?>\[\d+\]<\/a>/) do 
      footnote($1)
    end
    html.gsub!(/<div id=ftn\d+>(.*?)<\/div>/im,'')
  end
  
  def footnote(number)
    footnote = html[/<div id=ftn#{number}>(.*?)<\/div>/im,1]
    footnote.gsub!(/\n+/,' ')
    footnote.gsub!(/<a href="#_ftnref.*?<\/a>/im,'')
    footnote.gsub!(/<\/?p.*?>/im,'')
    "["+footnote.strip+"]"
  end
  
  def replace_links_19
    html.gsub!(/<a href="(.*?)".*?>(.*?)<\/a>/im) do
      "#{$2}[#{$1.strip}]"
    end
  end
   
  def replace_bold_and_underline_20
    %w{b u em i}.each do |tag|
      html.gsub!(/<#{tag}.*?>(.*?)<\/#{tag}>/im) do |m|
        if $1.strip.size == 0
          ""
        else
          "*#{$1.gsub("\n"," ")}*"
        end
      end
    end
  end
  
  def create_number_lists_21
    html.gsub!(/\n *\d+[a-z]?\.?\)? +/i,"# ")
    html.gsub!(/\n *i+\. +/i,"# ")
  end
  
  def create_number_lists_from_uls_22
    html.gsub!(/<ol.*?>(.*?)<\/ol>/im) do
      $1.gsub!(/<li.*?>(.*?)<\/li>/im) do
        "# "+$1.strip.gsub("\n"," ") + "\n"
      end
    end
  end
    
  def remove_spacing_between_number_lists_23
    html.gsub!(/\n# *([^\n]*)\n\s*(?=\n#)/m) do |m|
      "\n# #{$1}"
    end
  end
  
  def replace_double_stars_24
    html.gsub!('**','')
  end
  
  def replace_almost_headings_25
     html.gsub!(/\n *\*([^*]*)\* *\n/im) do |m|
       if $1.strip.size == 0
         ""
       else
         "h4 #{$1}\n\n"
       end
     end    
   end
  
  def remove_straplines_9
    html.gsub!(/<p class=Strapline>.*?<\/p>/im,'')
  end
  
  def remove_any_remaining_tags_99
    html.gsub!(/<\/?.*?\/?>/im,'')
  end
  
  def remove_unwanted_newlines_and_spaces_100
    html.gsub!(/\n\s+\n/im,"\n\n")
    html.gsub!(/\n\n\n+/,"\n\n")
    html.gsub!(/ +/m,' ')
  end  
  
  def remove_briefing_references_200
    html.gsub!(/ – briefing \d+[a-z]*/mi,'')
  end
  
  def remove_section_references_205
    html.gsub!(/Section [A-Z] –/,'')
  end
  
  def remove_numbers_in_h4s_206
    html.gsub!(/\nh4 \d+\./i,"\nh4 ")
  end
  
  def replace_pictures_in_tables_210
    html.gsub!(/\| *(insert picture \S+) *\|/im) do
      "\n\n#{$1}\n\n"
    end
  end
  
  def remove_empty_tables_220
    html.gsub!(/\n\n(\|\s+)*?\n\n/im,"\n\n")
  end
  
  def replace_links_with_references_when_implied_230
    html.gsub!(/:\n+(http:.*?)\n/im) do 
      "[#{$1}]\n"
    end
  end
  
  def write
    @counter ||= 0
    File.open("progress-#{@counter}",'w') { |f| f.puts html }
    @counter += 1
  end
  
end

convertor = ConvertHtmlToSokcloth.new(IO.readlines(ARGV[0]).join)
convertor.convert