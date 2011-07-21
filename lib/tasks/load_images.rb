directory = Dir.new(ARGV[0])

user = User.find(:first)
puts user.name
User.current = user

directory.entries.each do |entry|
  filename =  File.join(directory,entry)
  title =  "picture #{File.basename(entry,".*")}"
  next if title =~ /picture \.+/
  puts "Loading #{title} from #{filename}"
  picture = Picture.find_or_initialize_by_title title
  picture.picture = File.new(filename)
  picture.save!
  puts "ok"
end
