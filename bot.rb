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
    puts config['plugins'].inspect

    c.plugins.plugins = config['plugins'].map {|p| Kernel.const_get p}

    c.plugins.options[Wolfram][:wolfram_url] = config['wolfram_url']
    c.plugins.options[Wolfram][:wolfram_appid] = config['wolfram_appid']
    c.plugins.options[GoogleSearch][:google_developer_key] = config['google_developer_key']
    c.plugins.options[Youtube][:google_developer_key] = config['google_developer_key']
    c.plugins.options[Cinch::HttpServer] = {
        :host => config['http_server_host'],
        :port => config['http_server_port']
        #:logfile => "/var/log/cinch-http-server.log" # OPTIONAL
    }
    c.plugins.options[ForecastIO][:forecast_io_url] = config['forecast_io_url']
    c.plugins.options[ForecastIO][:forecast_io_api_key] = config['forecast_io_api_key']

    c.channels = config['channels']
  end
end

bot.start
