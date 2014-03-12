require 'cinch'
require 'yaml'

config = YAML.load_file(File.dirname(__FILE__) + '/config.yml')
puts "postgres://#{config['db_username']}:#{config['db_password']}@#{config['db_host']}/#{config['database']}"

Dir.glob(File.dirname(__FILE__) + "/plugins/*.rb").each { |file| require_relative file }
require_relative 'helpers'
require 'data_mapper'
require 'dm-postgres-adapter'

Dir.glob(File.dirname(__FILE__) + "/models/*.rb").each { |model| require_relative model }
DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
DataMapper.setup(:default, "postgres://#{config['db_username']}:#{config['db_password']}@#{config['db_host']}/#{config['database']}")
DataMapper.finalize
DataMapper.auto_upgrade!

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
    c.plugins.options[Private][:master_user] = config['master_user']

    c.channels = config['channels']
  end
end

bot.start
