sokcloth = IO.readlines(ARGV[0]).join

def split(text,level = 1)
  return text if level > 4
  text.split(/^(h#{level} .*?\n)/im).map do |t|
    if t =~ /^h#{level}/
      t
    else
      split(t,level + 1)
    end
  end
end

user = User.find(:first)
puts user.name
User.current = user

split_sokcloth = sokcloth.split(/^(h[123]+ .*?\n)/im)

categories = ["Factual Briefing for the May 2010 election"]
titles_used = []

split_sokcloth.each do |section|
  # p section
  case section
  when /^h1 (.*?)\n/im
    categories[1] = $1
  when /^h2 (.*?)\n/im
    categories[2] = $1
  when /^h3 (.*?)\n/im
    categories[3] = $1
  else
    categories[3] ||= categories[2] ||= categories[1] ||= categories[0]
    if (categories[3] == "Key facts and data" || categories[3].strip.size == 0)
      categories[3] = categories[2]
    end
    while titles_used.include?(categories[3])
      if categories[3] =~ /\d$/i
        categories[3] = categories[3].succ
      else
        categories[3] = categories[3] + " part 2"
      end
    end
    titles_used << categories[3]
    cats = categories.dup
    cats.delete(categories[3])
    cats = cats.uniq.map(&:downcase)

    title = categories[3]
    content = section.gsub(/^h4/,"h1")
    unless cats.empty?
      content << "\n\nCategories: #{cats.join('; ')}\n\n"
    end
    
    puts "Saving #{title}"
    page = Page.find_or_create_by_title(title)
    page.content = content
    page.save!
    
    categories[3] = nil
  end
end
