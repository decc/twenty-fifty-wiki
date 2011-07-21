# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
require 'csv'
Mime::Type.register "text/tsv", :tsv

Mime::Type.register "application/msword", :doc
Mime::Type.register "application/pdf", :pdf, ['text/pdf'], ['pdf']
Mime::Type.register "application/x-latex", :latex

# Mime::Type.register "message/rfc822", :doc
