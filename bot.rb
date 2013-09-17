require 'cinch'
require 'mechanize'
require 'open-uri'
require 'json'

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
    c.server = "pucksteak"
	c.nick = "onewheelskybot"
	c.user = "onewheelskybot"
	c.realname = "onewheelskybot"
	c.password = "password"
	c.port = 1919

    #c.channels = ["#pdxbots"]
  end

  on :message, /onewheelskybot (.*)/ do |m, element|
    case element
		when /^image/i
			reply = handle_image(element.gsub /image\s*m*e*\s*/, '')
	end
	m.reply reply
  end
end

bot.start
