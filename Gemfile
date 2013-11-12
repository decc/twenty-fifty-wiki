source 'http://rubygems.org'
ruby "2.0.0"

gem 'rails',  '3.2.11'
gem 'prototype-rails'
gem 'sass-rails', '~> 3.2.3'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'
gem 'thin'
gem "haml" # For html templates
gem "haml-rails" # For haml generators to work
gem "devise" # For user management
gem "aws-sdk" # To use amazon S3 as a file store
gem 'paperclip' # For file attachments
gem "delayed_job_active_record" # For updating associated pages
gem 'sunspot_rails'
gem "will_paginate"
gem 'exception_notification'
gem "rails-latex", :git => "git://github.com/tamc/rails-latex.git"
gem "sanitize" # To prevent malicious html
gem "foreman"
gem "recaptcha", :require => "recaptcha/rails"

gem "pg" # required by postgresql

group :development do
  gem 'sunspot_solr'
end

group :test do
  gem 'sqlite3'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'   # so we can use : Then show me the page
  gem 'machinist'
  gem 'faker'
  gem 'nokogiri'
  gem 'email_spec'
end
