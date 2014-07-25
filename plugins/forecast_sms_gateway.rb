require 'json'
require 'httparty'
require_relative 'http_server'
require 'twilio-ruby'

class ForecastSmsGateway
  include Cinch::Plugin
  extend Cinch::HttpServer::Verbs

  # Twillio response block
  get '/forecast' do
    bot = self.bot
    request, query = params[:Body].split ' '

    query = get_personalized_query('twillio text', 'weather', query)
    forecast = bot.plugins[4].get_forecast_io_results query

    case request
      when /^forecast/i
        text = bot.plugins[4].get_weather_forecast(request.sub /^forecast\s*/i, '')
      when /^rain/i
        text = bot.plugins[4].sms_rain_forecast request.sub(/^rain\s*/i, '')
      when /^temp/i
        text = bot.plugins[4].do_the_temp_thing(forecast, %w[_ ▁ ▃ ▅ ▇ █], 24)
      when /^cond/i
        text = bot.plugins[4].conditions(forecast)
      when /^say/i
        text = request.sub /^say /i, ''
        bot.Channel('#pdxtech').send(text)
      when /^wifi/i
        text = request.sub /^wifi /i, ''
        bot.Channel('#pdxtech').send("what is #{text} wifi password?")
      else
        text = bot.plugins[4].get_weather_forecast(request)
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message text
    end
    twiml.text
  end

end

