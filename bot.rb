require 'cinch'
require 'yaml'

config = YAML.load_file('config.yml')
Dir.glob("plugins/*.rb").each { |file| require_relative file }

bot = Cinch::Bot.new do
  configure do |c|
    c.server = config['server']
    c.nick = config['nick']
    c.user = config['user']
    c.realname = config['realname']
    c.password = config['password']
    c.port = config['port']
    c.plugins.plugins = [Images]
    #c.plugins.options[Cinch::Plugins::Images][:nick] = config['nick']
    #c.channels = ["#pdxbots"]
  end

  #on :message, /#{config['nick']} (.*)/ do |m, element|
  #  case element
  #    when /^image/i
  #      reply = handle_image(element.gsub /image\s*m*e*\s*/, '')
  #  end
  #  m.reply reply  if reply
  #end
end

bot.start
