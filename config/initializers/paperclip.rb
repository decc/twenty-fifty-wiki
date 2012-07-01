Paperclip::Attachment.default_options[:url] = "/uploads/:class/:attachment/:id/:style.:extension"
Paperclip::Attachment.default_options[:default_url] = ""
Paperclip::Attachment.default_options[:styles] = { :medium => ["600x400>",:jpg], :thumb => ["100x100>",:jpg] }
Paperclip::Attachment.default_options[:convert_options] = { :all => "-flatten" }
