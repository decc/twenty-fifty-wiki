source 'http://rubygems.org'
gem 'rails', '3.0.3'
gem 'thin'
gem "haml" # For html templates
gem "haml-rails" # For haml generators to work
gem "devise" # For user management
gem 'paperclip' # For file attachments
gem "delayed_job" # For updating associated pages
gem 'sunspot_rails', '1.2.1' # For search
gem "will_paginate", "~> 3.0.pre2"
gem 'exception_notification', :require => 'exception_notifier'
gem "rails-latex", :git => "git://github.com/tamc/rails-latex.git"

group :development do 
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :production do
  gem "pg" # required by postgresql
  # gem "mysql2", "~> 0.2.7"
end

group :testing do
  gem 'autotest'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'   # so we can use : Then show me the page
  gem 'machinist', '>= 2.0.0.beta1'
  gem 'faker'
  gem 'nokogiri'
  gem 'email_spec'
end
