require 'mechanize'
require 'open-uri'
require 'json'
require 'google/api_client'
require 'trollop'

class Youtube
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /yo*u*t*u*b*e*\s*m*e*\s(.*)/i, method: :google_search #, react_on: :channel

  set :help, <<-EOF
[/msg] youtube me [x]
  Display an youtube of [x]
  EOF

  def google_search(msg, query)
    index = get_index(query)

    req = ApiRequest.first_or_create(type: :youtube, request: query)
    if req.reply
      parsed = JSON.parse req.response
      search_url, search_text = get_search_url_and_text(parsed, index)
      msg.reply("* #{format_reply_string(search_text, search_url)}")
    else
      #url = get_api_url(query)
      # Set DEVELOPER_KEY to the "API key" value from the "Access" tab of the
      # Google APIs Console <http://code.google.com/apis/console#access>
      # Please ensure that you have enabled the YouTube Data API for your project.
      dev_key = "AIzaSyA_HzTphL3pazvBr6GfPcdVQIL0KSm-qco"

      opts = Trollop::options do
        opt :q, 'Search term', :type => String, :default => 'Google'
        opt :maxResults, 'Max results', :type => :int, :default => 25
      end

      client = Google::APIClient.new(:key => dev_key,
                                     :authorization => nil)
      youtube = client.discovered_api('youtube', 'v3')

      opts[:part] = 'id,snippet'
      opts[:q] = query
      search_response = client.execute!(
          :api_method => youtube.search.list,
          :parameters => opts
      )
      parsed = JSON.parse search_response.response.body
      search_url, search_text = get_search_url_and_text(parsed, index)

      req.response = search_response.response.body
      req.reply = format_reply_string(search_text, search_url)
      req.save

      msg.reply(req.reply)    if req.reply
    end
  end

  def get_index(query)
    index = 0
    if query =~ /\[(\d+)\]$/
      query.gsub! /\[(\d+)\]$/, ''
      index = $1.to_i
    end
    index
  end

  def format_reply_string(search_text, search_url)
    "#{search_text} #{search_url}"
  end

  def get_search_url_and_text(parsed, index)
    #Todo: Return a different image if this one has been used.
    #agent = Mechanize.new
    #link = "http://youtube.com/watch?v=" + parsed['items'][index]['id']['videoId']
    link = " http://y2u.be/" + parsed['items'][index]['id']['videoId']
    if link
      return link, parsed['items'][index]['snippet']['title']
    end
  end

  def on_connect(msg)
    @agent = Mechanize.new
  end
end
