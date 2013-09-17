require 'cinch'
require 'mechanize'
require 'open-uri'
require 'json'
require 'yaml'

config = YAML.load_file('config.yml')

def handle_image(search_term)
  url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{URI::encode search_term}"
  agent = Mechanize.new
  agent.get(url) do |result|
    parsed = JSON.parse result.body
    return parsed['responseData']['results'][0]['url']
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = config['server']
    c.nick = config['nick']
    c.user = config['user']
    c.realname = config['realname']
    c.password = config['password']
    c.port = config['port']

    #c.channels = ["#pdxbots"]
  end

  on :message, /#{config['nick']} (.*)/ do |m, element|
    case element
      when /^image/i
        reply = handle_image(element.gsub /image\s*m*e*\s*/, '')
    end
    m.reply reply  if reply
  end
end

bot.start
