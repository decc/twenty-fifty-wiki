module PagesHelper
  
  def redirect_message
      return nil unless params[:redirect_from]
      original_page = Title.where(:title => params[:redirect_from].downcase, :target_type => 'Page').first.try(:target)
      return nil unless original_page
      raw("<div id='redirect'>N.B., you were redirected here from '#{link_to original_page.title, page_url(original_page,:no_redirect => true)}'</div>")
  end
  
  def extract_pictures_from(html)
    pictures = []
    @html.gsub!(/<img src='(.*?)'/) do |match|
      filename = $1[/^(.*)\?/,1]
      pictures << filename
      "<img src='http://decc-wiki.greenonblack.com#{filename}'"
    end
    pictures.map do |picture|
      separator(picture)+Base64.encode64(read_binary_file(picture)).gsub(/\n/, '')
    end.join('')
  end
  
  def separator(picture)
"
------=_NextPart_000_0000_01CB7C50.119ED180
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Location: http://decc-wiki.greenonblack.com#{picture}

"
  end

  def read_binary_file(path)
    File.open(File.join(Rails.root,'public',path), 'r:binary') {|f| f.read }
  end
  
end
