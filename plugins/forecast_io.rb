require 'json'
require 'httparty'
require_relative 'http_server'
require 'twilio-ruby'
require_relative 'forecastio_methods'

class ForecastIO
  include Cinch::Plugin
  include ForecastIOMethods
  extend Cinch::HttpServer::Verbs

  match /(forecast)\s*(.*)$/i,                method: :execute
  match /(weather)\s*(.*)$/i,                 method: :execute
  match /(asciithefuckingweather)\s*(.*)$/i,  method: :execute
  match /(asciirain)\s*(.*)/i,                method: :execute
  match /(asciisnow)\s*(.*)/i,                method: :execute
  match /(ansirain)\s*(.*)/i,                 method: :execute
  match /(ansicloud)s*\s*(.*)/i,              method: :execute
  match /(dailyrain)\s*(.*)/i,                method: :execute
  match /(ansisnow)\s*(.*)/i,                 method: :execute
  match /(asciiozone)\s*(.*)/i,               method: :execute
  match /(asciitemp)\s*(.*)/i,                method: :execute
  match /(ansitemp)\s*(.*)/i,                 method: :execute
  match /(asciiwind)\s*(.*)/i,                method: :execute
  match /(ansiwind)\s*(.*)/i,                 method: :execute
  match /(winddir)\s*(.*)/i,                  method: :execute
  match /(asciisun)\s*(.*)/i,                 method: :execute
  match /(ansisun)\s*(.*)/i,                  method: :execute
  match /(7day)\s*(.*)/i,                     method: :execute
  match /(alerts)\s*(.*)/i,                   method: :execute
  match /(condi*t*i*o*n*s*)\s*(.*)/i,         method: :execute
  match /(rain)\s*(.*)/i,                     method: :execute

  set :help, <<-EOF
This is the weather prediction module.  Location is optional, and defaults to Portland, OR.
Once you specify a location, it will persist as long as you own your nick.
!forecast   [location] Forecast IO forecast for Portland.
!asciirain  [location] Incoming rain data for the next hour.
!ansirain   [location] Fancy incoming rain data for the next hour.
!dailyrain  [location] Rain forecast for the next 24 hours.
!asciiozone [location] Ozone data for the next 24 hours.
!asciitemp  [location] 24 hours of temperature data.
!ansitemp   [location] 24 hours of fancy temperature data.
!asciiwind  [dir] [location] 24 hours of wind speed data.  Option dir retrieves wind direction data.
!ansiwind   [dir] [location] 24 hours of fancy wind speed data.  Option dir retrieves wind direction data.
!asciisun   [location] 7 days of sun likelihood data.
!asciisun   [location] 7 days of sun likelihood data, fancy style.
!7day       [location] 7 days of temperature data.
!alerts     [location] NOAA alerts for your location, if available.
!conditions [location] get a summary of conditions.
!forecast   set scale [c|f] Change your temperature scale.  This works with all available commands.
!rain       Yesno?
  EOF

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
