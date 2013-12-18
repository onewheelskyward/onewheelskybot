require 'mechanize'
require 'open-uri'
require 'json'
require_relative 'google_abstract'

class Images < GoogleAbstract
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /im*a*g*e*\s*m*e*\s(.*)/i, method: :image_search #, react_on: :channel
  match /ping$/, method: :pong
  match /^ping$/, use_prefix: false, method: :pong

  set :help, <<-EOF
[/msg] image me [x]
  Display an image of [x]
[/msg] ping
  pong
  EOF

  def get_google_url(query)
    "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{URI::encode query}"
  end

  def image_search(msg, query)
    index = get_index query
    url = get_google_url query

    image_url = nil
    req = ApiRequest.first_or_create(type: :image, request: query)
    if req.reply
      msg.reply("* #{req.reply}")
    else
      result = api_call(url)
      parsed = JSON.parse result
      image_url = get_image_url(parsed)

      req.response = result
      req.reply = image_url
      req.save

      msg.reply(image_url)    if image_url
    end
  end

  def get_image_url(parsed)
    #Todo: Return a different image if this one has been used.
    agent = Mechanize.new
    parsed['responseData']['results'].each do |image|
      puts "Image URL: #{image['url']}"
      if image['url']
        begin
          info = agent.head(image['url'])
          return image['url']
        rescue Mechanize::ResponseCodeError => e
          puts "image['url'] not found. #{e.inspect}"
        end
      end
    end
  end

  def api_call(url)
    agent = Mechanize.new
    result = agent.get(url)
    result.body
  end

  def get_search_url_and_text(json, index)
    #Todo: Return a different image if this one has been used.
    #agent = Mechanize.new
    parsed = JSON.parse json
    link = parsed['responseData']['results'][index]
    if link['url']
      return link['url'], link['titleNoFormatting']
    end
  end

  def pong(msg)
    pong_images = %w(http://img209.imageshack.us/img209/366/toast.gif
                     http://i.imgur.com/cRgZZca.gif
                     https://dl.dropboxusercontent.com/u/575564/apecgnU.gif
                     http://i.imgur.com/1LG3p1Q.gif
                     http://cdn.memegenerator.net/instances/500x/43965451.jpg
                     http://30.media.tumblr.com/tumblr_m3056cCdb71rr3l61o1_500.gif
                     http://giphy.com/gifs/Us2YBZNhO8Pba/tiled
                     http://media.giphy.com/media/2WhCMpG85VhWE/giphy.gif
                     http://media.giphy.com/media/rUCzODGkQF8GY/giphy.gif
                    )
    msg.reply("#{pong_images.sample}")
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
