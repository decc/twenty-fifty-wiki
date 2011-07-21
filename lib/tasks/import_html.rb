class ScanAndSplit
  
  attr_accessor :original_html, :levels_to_promote_headings
  attr_accessor :sokcloth
  attr_accessor :images
  
  def initialize(original_html,levels_to_promote_headings = 3)
    self.original_html = original_html
    self.levels_to_promote_headings = levels_to_promote_headings
    self.images = []
  end
  
  def convert
    self.sokcloth = [];
    index_of_tag = 0
    while new_index = original_html.index(/<(.*?)>/mo,index_of_tag)
      match = Regexp.last_match
      # puts match[0]
      string original_html[index_of_tag...new_index]
      tag match[0]
      index_of_tag = match.end(0)
    end
    self.sokcloth = self.sokcloth.join
    post_process
    sokcloth
  end
  
  def tag(tag)
    case tag
    when /<a href="#_ftn(\d+)/mi; s footnote($1)
    when /<p.*?mso-outline-level:(\d)/mi; s heading_level($1)
    when /<p class=MsoListParagraph/mi; s "* "
    when /<\/?b>/; s "*"
    when /<\/p/i; s paragraph
    when /<h(\d+)/i; s heading_level($1)
    when /<\/h(\d+)/i; s "\n\n"
    when /<img[^s]+src="(.*?)"/im; s image($1)
    when /<table/i; s table_start
    when /<\/td/i; s table_cell_end
    when /<tr/i; s table_row_start
    when /<\/tr/i; s table_row_end
    when /<\/table/i; s table_stop
    end
  end  
  
  def string(string)
    s string.gsub(/[\r\n]+/,' ').gsub('&nbsp;',' ').gsub('&amp;','&')
  end
  
  def heading_level(number)
    new_level = number.to_i - levels_to_promote_headings
    return "NEWFILE\nh0 " if new_level < 1
    return "h#{new_level} "
  end
  
  def paragraph
    return "" if @inhibit_paragraphs
    "\n\n"  
  end
  
  def footnote(number)
    puts "Looking for footnote #{number}"
    footnote = original_html[/<div id=ftn#{number}>(.*?)<\/div>/im,1]
    puts "Found #{footnote}"
    footnote
  end
  
  def image(source)
    self.images << source
    "\n\ninsert imported picture number #{images.size}\n\n"
  end
  
  def table_start
    @inhibit_paragraphs = true
    "\n\n"
  end
  
  def table_cell_end
    " |"
  end
  
  def table_row_start
    "| "
  end
  
  def table_row_end
    "\n"
  end
  
  def table_stop
    @inhibit_paragraphs = false
    "\n\n"
  end
  
  def s(text)
    return if text == ""
    sokcloth << text
  end
  
  def post_process
    sokcloth.gsub!(/\[(.*?)\]/) { "(#{$1})"}
    sokcloth.gsub!(/^ +/,'')
    sokcloth.gsub!(/ +/,' ')
    sokcloth.gsub!(/^\*[ *]*([^*]*)\*$/) { "\h#{levels_to_promote_headings} #{$1.strip}" }
    sokcloth.gsub!(/^(h\d+) +\d+[a-z]?\.?/) {$1}
    sokcloth.gsub!(/^\d+\.?/,'#')
    sokcloth.gsub!(/^\* o /,'* ')
    sokcloth.gsub!(/^· /,'* ')
    sokcloth.gsub!(/^\*[^a-zA-Z0-9*]+/,'* ')
    sokcloth.gsub!(/(\n\n)\n+/,"\n\n")
    sokcloth.gsub!(/^\* ([^\n]*)\n\n(?=\* )/m) { "* #{$1}\n"}
    sokcloth.gsub!(/^\n\n\* ([^\n]*)\n\n(?!\* )/m) { "* #{$1}\n"}
    sokcloth.gsub!(/^# ([^\n]*)\n\n(?=# )/m) { "# #{$1}\n"}
  end
  
end

scan_and_split = ScanAndSplit.new(IO.readlines(ARGV[0]).join("\n"))
sokcloth = scan_and_split.convert
File.open('scanned_and_split.sokcloth','w') { |f| f.puts sokcloth }
File.open('scanned_and_split_images.sokcloth','w') { |f| f.puts scan_and_split.images.join("\n") }
# sokcloth = IO.readlines('scanned_and_split.sokcloth').join

user = User.find(:first)
puts user.name
User.current = user

sokcloth.split(/^NEWFILE$/).each do |newfile|
  title = newfile[/h0 (.*?)\n/,1]
  puts "No title found for: #{newfile}" unless title
  next unless title
  title = title + "- xxx -" if title.size <= 3
  content = newfile.gsub(/h0 (.*?)\n/,'')
  size = content.split("\n").size
  if size > 1
    puts "#{title} (#{size})"
    page = Page.find_or_create_by_title(title)
    page.content = content + "\n\nCategories: Factual briefing 2010"
    page.save!
  end
end

image_file_base = File.join(File.dirname(ARGV[0]),'images')

include Timeout

scan_and_split.images.each_with_index do |source,i|
  source = File.join(image_file_base,File.basename(source))
  p "Loading #{source}"
  p File.exists?(source)
begin
  Timeout.timeout(5) do
    picture = Picture.find_or_initialize_by_title "imported picture number #{i+1}"
    picture.picture = File.new(source)
    picture.save!
  end
rescue Timeout::Error
  p "Failed"
end
end
# each do |newfile|
#   puts newfile
#   newfile = newfile.split("\n")
#   newfile.shift
# end
