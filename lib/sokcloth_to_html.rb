require_relative 'sokcloth_parser'

class SokclothToHtml
  
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
    level = level.to_i+@heading_shift
    "<h#{level}>#{visit(contents)}</h#{level}>"
  end
  
  def table(*contents)
    "<table>#{visit(contents)}</table>"
  end
  
  def table_row(*contents)
    "<tr>#{visit(contents)}</tr>"
  end
  
  def table_cell(*contents)
    "<td>#{visit(contents)}</td>"
  end
  
  def bullet_list(*contents)
    "<ul>\n#{visit(contents)}</ul>"
  end

  def number_list(*contents)
    "<ol>\n#{visit(contents)}</ol>"
  end
  
  def list_line(*contents)
    "<li>#{visit(contents)}</li>\n"
  end
  
  def paragraph(*contents)
    "<p>#{visit(contents) }</p>"
  end
  
  def emphasis(*contents)
    "<em>#{visit(contents)}</em>"
  end
  
  def outline(*contents)
    #return visit(contents) if @heading_shift == 1
    return increment_heading_level { visit(contents) }
  end
  
  def insert(title,page_content = nil)
    increment_heading_level do
      insert_without_increment(title,page_content)
    end
  end
  
  def insert_without_increment(title,page_content = nil)
    return visit(page_content) if page_content
    url = (title =~ /^picture|image|graph/i) ? 
      "/pictures/new?picture[title]=#{title}" : 
      "/pages/new?page[title]=#{title}"
    "<div class='missinginsert'>[insert <a href='#{url}' class='missing'>#{title}</a>]</div>"    
  end
  
  def summarise(title,page_content = nil)
    return increment_heading_level { visit(page_content) } if page_content
    url = (title =~ /^picture|image/i) ? 
      "/pictures/new?picture[title]=#{title}" : 
      "/pages/new?page[title]=#{title}"
    "<div class='missinginsert'>[insert <a href='#{url}' class='missing'>#{title}</a>]</div>"
  end
  
  def increment_heading_level(increment_by = 1) 
    @heading_shift = @heading_shift + increment_by
    result = yield
    @heading_shift = @heading_shift - increment_by
    result
  end
  
  def citation(target,text)
    "<a href='#{target}'><sup>#{text}</sup></a>"
  end
  
  def references(*contents)
    "<div class='references'><div class='divider'>&nbsp;</div>#{visit(contents)}</div>"
  end
  
  def jump_from(target,text = target)
    "<a href='#{target}'>#{text}</a>"
  end
  
  def jump_to(target,*contents)
    "<span id='#{target}'>#{visit(contents)}</span>"
  end

  def figure(image_url,title = nil,caption = nil,link_to = nil, width = nil, height = nil)
    caption = nil if caption.empty?
    html = ["<div class='figure' style='#{width && "width: #{width}px;"}'>"]
    html << "<h4>Figure #{figure_number}: #{title}</h4>" if title
    html << "<a class='imagelink' href='#{link_to}'>" if link_to
    html << "<img src='#{image_url}' style='#{width && "width: #{width}px;"};#{height && "height: #{height}px;"}' />"
    html << "</a>" if link_to
    html << "<div class='caption'><p>#{visit(caption)}<span class='further_detail'>#{link_to && "<a href='#{link_to}'>[More]</a>"}</span></p></div>" if caption
    html << "</div>"
    html.join
  end
  
  def image(image_url,link_to = nil, width = nil, height = nil)
    html = ["<div class='image' style='#{width && "width: #{width}px;"}'>"]
    html << "<a class='imagelink' href='#{link_to}'>" if link_to
    html << "<img src='#{image_url}' style='#{width && "width: #{width}px;"};#{height && "height: #{height}px;"}' />"
    html << "</a>" if link_to
    html << "</div>"
    html.join
  end
  
  def figure_number
    @figure_number ||= 0
    @figure_number += 1
  end
  
  def link(href,text)
    "<a href='#{href}'>#{text}</a>"
  end
  
  def div(_class,*contents)
    "<div class='#{_class}'>#{visit(contents)}</div>"
  end
  
  def url(*contents)
    url = visit(contents)
    text = url
    if text =~ %r{2050-calculator-tool\.decc\.gov\.uk/pathways/([^/]+)}
      text = "Pathway #{$1[0..2]}&hellip;#{$1[-3..-1]}"
    end
    "<a href='#{(url =~ /^http/) ? url : "http://#{url}" }'>#{text}</a>"
  end
  
  def email(*contents)
    email = visit(contents)
    "<a href='mailto:#{email}'>#{email}</a>"
  end
  
  def matrix(document_id)
    # target_id = (document_id =~ /D(\d\d)\/(\d+)/) ? "D20#{$1}/#{$2}" : document_id
    target_id = document_id
    "<a href='http://sdcm2w01.dti.local:8265/GetDocument.aspx?number=#{target_id}' class='matrix'>#{document_id}</a>"
  end
  
  def category(*categories)
    # We ignore these here; they are picked up by the interlink scanning in the models
    ""
  end
  
  def visit(contents)
    contents.map {|c| c.visit(self) }.join
  end
end
