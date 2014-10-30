###
# XxxXORS mod
##
require 'json'
require 'httparty'
require 'uri'
require 'nokogiri'

class Amazon
  include Cinch::Plugin

  match /(http:\/\/www.amazon.com\/[^ ]*)/i, use_prefix: false, method: :execute

  set :help, <<-EOF
  Amazon url parser
  EOF

  def execute(msg, query)
      response = HTTParty.get query
      noko_obj = Nokogiri.HTML response.body
      title = noko_obj.css("title")
      msg.reply title.children
  end
end
