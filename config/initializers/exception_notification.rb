Rails.application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[DECC-WIKI] ",
  :sender_address => %{"DECC WIKI" <joseph.downie@decc.gsi.gov.uk.decc.wiki@gmail.com>},
  :exception_recipients => %w{tom@counsell.org tom.counsell@decc.gsi.gov.uk}