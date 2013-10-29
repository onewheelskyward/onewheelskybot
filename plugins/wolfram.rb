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
  match /sunrise$/i, method: :sunrise
  match /sunset$/i, method: :sunset
  match /moonrise$/i, method: :moonrise
  match /moonset$/i, method: :moonset
  match /moonphase$/i, method: :moonphase

  set :help, <<-EOF
[/msg] !alpha [me] [x]
  Wolfram Alpha search for [x]
[/msg] !sunrise
[/msg] !sunset
[/msg] !moonrise
[/msg] !moonset
[/msg] !moonphase
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
    #req = ApiRequest.first_or_create(type: :wolfram, request: query)
    req = ApiRequest.create(type: :wolfram, request: query)
    #if req.reply
    #  reply = parse_search_result(req.response)
    #  msg.reply("* #{reply}")
    #else
      xml = query_wolfram_alpha(query)
      req.response = xml
      reply = parse_search_result(xml)
      req.reply = reply.to_s.gsub "\n", "  /  "
      req.save
      msg.reply(req.reply)  if req.reply
    #end
  end

  def sunrise(msg)
    wolfram_alpha_search(msg, 'sunrise pdx')
  end

  def sunset(msg)
    wolfram_alpha_search(msg, 'sunset pdx')
  end

  def moonrise(msg)
    wolfram_alpha_search(msg, 'moonrise pdx')
  end

  def moonset(msg)
    wolfram_alpha_search(msg, 'moonset pdx')
  end

  def moonphase(msg)
    wolfram_alpha_search(msg, 'moon phase pdx')
  end


end
