require 'mechanize'
require 'open-uri'
require 'json'

class Google
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /go*o*g*l*e*\s*m*e*\s(.*)/i, method: :google_search #, react_on: :channel

  set :help, <<-EOF
[/msg] image me [x]
  Display an image of [x]
  EOF

  def get_google_url(query)
    "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{URI::encode query}"
  end

  def google_search(msg, query)
    index = get_index(query)
    url = get_google_url(query)

    image_url = nil
    req = ApiRequest.first_or_create(type: :google, request: query)
    if req.reply
      parsed = JSON.parse req.response
      search_url, search_text = get_search_url_and_text(parsed, index)
      msg.reply("* #{format_reply_string(search_text, search_url)}")
    else
      result = api_call(url)
      parsed = JSON.parse result
      search_url, search_text = get_search_url_and_text(parsed, index)

      req.response = result
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
    link = parsed['responseData']['results'][index]
    if link['url']
      return link['url'], link['titleNoFormatting']
    end
  end

  def api_call(url)
    agent = Mechanize.new
    result = agent.get(url)
    result.body
  end


  # Called on startup. This method iterates the list of registered plugins
  # and parses all their help messages, collecting them in the @help hash,
  # which has a structure like this:
  #
  #   {Plugin => {"command" => "explanation"}}
  #
  # where +Plugin+ is the plugin’s class object. It also parses configuration
  # options.
  def on_connect(msg)
    @agent = Mechanize.new
    #@help = {}

    #if config[:intro]
    #  @intro_message = config[:intro] % bot.nick
    #else
    #  @intro_message = "#{bot.nick} at your service."
    #end

    #bot.config.plugins.plugins.each do |plugin|
    #  @help[plugin] = Hash.new{|h, k| h[k] = ""}
    #  next unless plugin.help # Some plugins don't provide help
    #  current_command = "<unparsable content>" # For not properly formatted help strings
    #
    #  plugin.help.lines.each do |line|
    #    if line =~ /^\s+/
    #      @help[plugin][current_command] << line.strip
    #    else
    #      current_command = line.strip.gsub(/cinch/i, bot.name)
    #    end
    #  end
    #end
  end
end
