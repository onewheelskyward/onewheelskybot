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
    c.plugins.plugins = [Images, Wolfram, GoogleSearch, Youtube, ForecastIO, RubyEval]
    c.plugins.options[Wolfram][:wolfram_url] = config['wolfram_url']
    c.plugins.options[Wolfram][:wolfram_appid] = config['wolfram_appid']
    c.plugins.options[GoogleSearch][:google_developer_key] = config['google_developer_key']
    c.plugins.options[Youtube][:google_developer_key] = config['google_developer_key']
    c.plugins.options[ForecastIO][:forecast_io_url] = config['forecast_io_url']
    c.plugins.options[ForecastIO][:forecast_io_api_key] = config['forecast_io_api_key']

    c.channels = ["#booberries"]
  end
end

bot.start
