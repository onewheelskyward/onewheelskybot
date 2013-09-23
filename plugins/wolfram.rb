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

  def get_app_id
    "&appid=" + config[:wolfram_appid]
  end

  def query_wolfram_alpha(query)
    url = config[:wolfram_url] + URI::encode(query) + get_app_id

    agent = Mechanize.new
    request = agent.get(url)
    request.body
  end

  def parse_search_result(xml)
    xml_doc = Nokogiri::XML xml

    xml_doc.xpath("//pod").each_with_index do |pod, index|
      if index == 1
        element = pod.xpath("subpod").first
        p element
        return element.xpath("plaintext").children.to_s
      end
    end

    if didyoumean = xml_doc.xpath("//didyoumean").first
      return "Did you mean #{didyoumean.children.to_s}?"
    end
  end

  def wolfram_alpha_search(msg, query)
    xml = query_wolfram_alpha(query)
    result = parse_search_result(xml)
    msg.reply(result)  if result
  end
end
