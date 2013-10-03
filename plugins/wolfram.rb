require 'mechanize'
require 'open-uri'
require 'json'
require 'nokogiri'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative '../models/api_request'

class Wolfram
  include Cinch::Plugin
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "postgres://localhost/skybot")
  DataMapper.finalize
  ApiRequest.auto_upgrade!

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /alpha\s*m*e*\s(.*)/i, method: :wolfram_alpha_search #, react_on: :channel

  set :help, <<-EOF
[/msg] !alpha [me] [x]
  Wolfram Alpha search for [x]
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
        plaintext = element.xpath("plaintext").children.to_s
        if plaintext == ""
          plaintext = element.xpath("img").attr("src").to_s
        end
        return plaintext
      end
    end


    if futuretopic = xml_doc.xpath("//futuretopic").first
      return futuretopic.attr("msg")
    end
    # If the query fails, wolfram often finds something else relevant.
    if didyoumean = xml_doc.xpath("//didyoumean").first
      return "Did you mean #{didyoumean.children.to_s}?"
    end
  end

  def wolfram_alpha_search(msg, query)
    # Check cache.
    req = ApiRequest.first_or_create(type: :wolfram, request: query)
    if req.reply
      reply = parse_search_result(req.response)
      msg.reply("* #{reply}")
    else
      xml = query_wolfram_alpha(query)
      req.response = xml
      reply = parse_search_result(xml)
      req.reply = reply.to_s.gsub "\n", "  /  "
      req.save
      msg.reply(req.reply)  if req.reply
    end
  end
end
