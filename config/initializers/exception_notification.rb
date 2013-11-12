Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[DECC-WIKI] ",
    :sender_address => 'decc.wiki@gmail.com',
    :exception_recipients => %w{tom@counsell.org tom.counsell@decc.gsi.gov.uk}
  }
