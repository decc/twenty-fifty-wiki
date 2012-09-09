Paperclip::Attachment.default_options[:styles] = { :medium => ["600x400>",:jpg], :thumb => ["100x100>",:jpg] }
Paperclip::Attachment.default_options[:convert_options] = { :all => "-flatten" }
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = { :access_key_id => ENV['S3_ACCESS_KEY_ID'], :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'], :bucket => ENV['S3_BUCKET']}
Paperclip::Attachment.default_options[:s3_host_name] = "s3-eu-west-1.amazonaws.com"

