require 'mechanize'
require 'open-uri'
require 'json'

class Images
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /image\s*m*e*\s(.*)/i, method: :image_search #, react_on: :channel

  set :help, <<-EOF
[/msg] image me [x]
  Display an image of [x]
  EOF

  def image_search(msg, query)
    url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{URI::encode query}"
    image_url = nil

    agent = Mechanize.new
    agent.get(url) do |result|
      parsed = JSON.parse result.body
      image_url = parsed['responseData']['results'][0]['url']
    end

    msg.reply(image_url)    if image_url
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