require 'mechanize'
require 'open-uri'
require 'json'
require_relative 'google_abstract'

class GoogleSearch < GoogleAbstract
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /go*o*g*l*e*\s*m*e*\s(.*)/i, method: :google_search #, react_on: :channel

  set :help, <<-EOF
!g[oogle] <search term>[index]  For instant Google results, right in IRC.  [index] is 0-n or * for a random result.
  EOF

  def get_google_url(query)
    "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{URI::encode query}"
  end

  def google_search(msg, query)
    index = get_index(query)
    url = get_google_url(query)

    req = ApiRequest.first_or_create(type: :google, request: query)
    if req.reply
      search_url, search_text = get_search_url_and_text(req.response, index)
      msg.reply("* #{format_reply_string(search_text, search_url)}")
    else
      result = api_call(url)
      search_url, search_text = get_search_url_and_text(result, index)
      req.response = result
      req.reply = format_reply_string(search_text, search_url)
      req.save
      msg.reply(req.reply)    if req.reply
    end
  end

  def format_reply_string(search_text, search_url)
    "#{search_text} #{search_url}"
  end

  def get_search_url_and_text(json, index)
    #Todo: Return a different image if this one has been used.
    #agent = Mechanize.new
    parsed = JSON.parse json
    if index == '*'
      link = parsed['responseData']['results'].sample
    else
      link = parsed['responseData']['results'][index]
    end

    if link['url']
      return link['url'], link['titleNoFormatting']
    end
  end
end
