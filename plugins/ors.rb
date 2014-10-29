###
# XxxXORS mod
##
require 'json'
require 'httparty'
require 'URI'
require 'nokogiri'

class ORS
  include Cinch::Plugin

  match /ors\s*(\d+\.\d+)$/i, method: :execute
  match /ors\s*([\w ]+)$/i, method: :search

  set :help, <<-EOF
This will simply redirect you to oregonlaws.org.
!ors xxx.xxx
  EOF

  def execute(msg, query)
      msg.reply "http://www.oregonlaws.org/ors/#{query}"
  end

  def search(msg, query)
    response = HTTParty.get "http://www.oregonlaws.org/?search=#{URI.encode query}"
    noko_obj = Nokogiri.HTML response.body
    noko_obj.css(".search_hit a").each do |elem|
      next if elem.children.to_s.match /§/ or elem.children.to_s == 'more like this'
      link_text = elem.children.to_s
      link_text.gsub! /<span class="highlight">/, ''
      link_text.gsub! /<\/span>/, ''
      msg.reply("http://oregonlaws.org" + elem['href'].to_s + ' ' + link_text)
      last
    end
  end
end
