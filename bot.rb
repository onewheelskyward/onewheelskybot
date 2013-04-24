require 'cinch'
require 'mechanize'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "pucksteak"
	c.nick = "onewheelskybot"
	c.user = "onewheelskybot"
	c.realname = "onewheelskybot"
	c.password = "password"
	c.port = 19191

    #c.channels = ["#pdxbots"]
  end

  on :message, "beer" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
end

bot.start
