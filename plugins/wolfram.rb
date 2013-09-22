require 'mechanize'
require 'open-uri'
require 'json'
require 'nokogiri'

class Wolfram
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /alpha\s*m*e*\s(.*)/i, method: :wolfram_alpha_search #, react_on: :channel

  set :help, <<-EOF
[/msg] !alpha me [x]
  Wolfram Alpha's [x]
  EOF

  def wolfram_alpha_search(msg, query)
    url = config[:wolfram_url] + URI::encode(query) + "&" + config[:wolfram_appid]

    agent = Mechanize.new
    agent.get(url) do |result|
      puts result.body
      xml_doc  = Nokogiri::SLOP result.body
      #xml_doc.pod['
      #parsed = JSON.parse result.body
      #image_url = parsed['responseData']['results'][0]['url']
    end

    #msg.reply(image_url)    if image_url
  end
end