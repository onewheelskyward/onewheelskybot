require 'json'
require 'httparty'
require_relative 'http_server'
require 'twilio-ruby'

# cbe69d2e1728dd7c5c04@cloudmailin.net   http://192.81.215.203/inbound/mail

class ForecastIO
  include Cinch::Plugin
  extend Cinch::HttpServer::Verbs

  match /forecast\s*(.*)$/i,                method: :execute #, react_on: :channel
  match /weather\s*(.*)$/i,                 method: :execute #, react_on: :channel
  match /asciithefuckingweather\s*(.*)$/i,  method: :execute #, react_on: :channel
  match /asciirain\s*(.*)/i,                method: :ascii_rain_forecast
  match /asciisnow\s*(.*)/i,                method: :ascii_rain_forecast
  match /ansirain\s*(.*)/i,                 method: :ansi_rain_forecast
  match /ansisnow\s*(.*)/i,                 method: :ansi_rain_forecast
  match /asciiozone\s*(.*)/i,               method: :ascii_ozone_forecast
  match /asciitemp\s*(.*)/i,                method: :ascii_temp_forecast
  match /ansitemp\s*(.*)/i,                 method: :ascii_temp_forecast
  match /7day\s*(.*)/i,                     method: :seven_day
  match /alerts\s*(.*)/i,                    method: :alerts

  set :help, <<-EOF
[/msg] !forecast
  Forecast IO forecast for Portland.
[/msg] !asciirain
  Incoming rain data for the next hour.
  EOF

  def ansi_chars
    %w[_ ▁ ▃ ▅ ▇ █]
  end

  def ozone_chars
    %w[・ o O ◎ ◉]
  end

  def ascii_chars
    %w[_ . - • * ']
  end

  get '/forecast' do
    bot = self.bot
    request = params[:Body]
    case request
      when /^forecast/i
        text = bot.plugins[4].get_weather_forecast(request.gsub /^forecast\s*/i, '')
      #when /^rain/i
      #  text = bot.plugins[4].do_the_ascii_thing(request.gsub /^asciirain\s*/i, '')
      when /^rain/i
        text = bot.plugins[4].do_the_ansi_thing(request.gsub /^rain\s*/i, '')
      when /^temp/i
        text = bot.plugins[4].do_the_ascii_temp_thing(request.gsub /^temp\s*/i, '')
      when /^say/i
        text = request.sub /^say /i, ''
        bot.reply
      else
        text = bot.plugins[4].get_weather_forecast(request)
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message text
    end
    twiml.text
  end

  def execute(msg, query = 'Portland')
    msg.reply get_weather_forecast(query)
  end

  def get_weather_forecast(query)
    forecast, long_name = get_forecast_io_results query
    format_forecast_message forecast, query, long_name
  end

  def get_gps_coords(query)
    query = 'Portland, OR' if query == ''
    if query =~ /\d+\.*\d*,\d+\.*\d*/
      return query
    end
    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI.escape query}&sensor=false"
    puts url
    response = HTTParty.get url
    return response['results'][0]['geometry']['location']['lat'].to_s + ',' + response['results'][0]['geometry']['location']['lng'].to_s, response['results'][0]['formatted_address']
  end

  def get_forecast_io_results(query = '45.5252,-122.6751')
    gps_coords, long_name = get_gps_coords query
    url = config[:forecast_io_url] + config[:forecast_io_api_key] + '/' + gps_coords.to_s
    puts url
    forecast = HTTParty.get url
    #puts request.body
    #forecast = JSON.parse request.body
    return forecast, long_name
  end

# °℃℉
  def get_dot(probability, char_array)
    if probability < 0 or probability > 1
      return '?'
    end

    if probability == 0
      return char_array[0]
    elsif probability <= 0.10
      return char_array[1]
    elsif probability <= 0.25
      return char_array[2]
    elsif probability <= 0.50
      return char_array[3]
    elsif probability <= 0.75
      return char_array[4]
    elsif probability <= 1.00
      return char_array[5]
    end
  end

  def get_ozone_dot(ozone, char_array)
    if ozone <= 260
      char_array[0]
    elsif ozone <= 275
      char_array[1]
    elsif ozone <= 295
      char_array[2]
    elsif ozone <= 305
      char_array[3]
    elsif ozone > 305
      char_array[4]
    end
  end

# ▁▃▅▇█▇▅▃▁ agj
  def ascii_rain_forecast(msg, query)
    query, key = determine_intensity(query)
    str = do_the_precip_thing(query, ascii_chars, key)
    msg.reply str
  end

  def ansi_rain_forecast(msg, query)
    query, key = determine_intensity(query)
    str = do_the_precip_thing(query, ansi_chars, key)
    msg.reply str
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
  end

  def determine_intensity(query)
    if query =~ /^intensity/
      query = query.gsub /^intensity\s*/, ''
      key = 'precipIntensity'
    else
      key = 'precipProbability'
    end
    return query, key
  end

  def do_the_precip_thing(query, chars, key)
    forecast, long_name = get_forecast_io_results query
    str = ''
    precip_type = 'rain'
    data_points = []
    forecast['minutely']['data'].each do |datum|
      data_points.push datum[key]
    end

    forecast['minutely']['data'].each do |datum|
      precip_type = 'snow' if datum['precipType'] == 'snow'
      differential = data_points.max - data_points.min
      if differential == 0
        percentage = 0
      else
        percentage = (datum[key] - data_points.min) / (differential)
      end
      str += get_dot percentage, chars
    end
    #  - 28800
    type_str = (key == 'precipProbability')? 'likelihood':'intensity'
    "#{long_name} #{precip_type} #{type_str} #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def ascii_ozone_forecast(msg, query)
    chars = ozone_chars
    # O ◎ ]

    forecast, long_name = get_forecast_io_results query
    str = ''
    first = last = nil
    forecast['hourly']['data'].each do |datum|
      unless first
        first = datum['ozone']
      end
      str += get_ozone_dot datum['ozone'], chars
      last = datum['ozone']
    end

    msg.reply "#{long_name} ozones #{first} |#{str}| #{last} [24h forecast]"
  end

  def ascii_temp_forecast(msg, query)
    str = do_the_ascii_temp_thing(query)
    msg.reply str
  end

  def do_the_ascii_temp_thing(query)
    forecast, long_name = get_forecast_io_results query
    str = ''
    first = last = nil
    high = -99999
    low = 99999

    forecast['hourly']['data'].each_with_index do |datum, index|
      temp = datum['temperature']
      if temp < low.to_f
        low = temp
      end

      if temp > high.to_f
        high = temp
      end
      break if index == 23
    end

    differential = high - low

    forecast['hourly']['data'].each_with_index do |datum, index|
      temp = datum['temperature']

      if index == 0
        first = temp
      end
      probability = (temp - low) / differential
      str += get_dot probability, ansi_chars
      last = temp
      break if index == 23
    end
    str = "#{long_name} temps: now #{first.round(1)}°F |#{str}| #{last.round(1)}°F this hour tomorrow.  Range: #{low.round(1)}-#{high.round(1)}°F"
  end

  def format_forecast_message(forecast, query, long_name)
    minute_forecast = forecast['minutely']['summary'].to_s.downcase.chop if forecast['minutely']
    "Weather for #{long_name} is currently #{forecast['currently']['temperature']}°F (#{celcius forecast['currently']['temperature']}°C) " +
    "and #{forecast['currently']['summary'].downcase}.  Winds out of the #{compass_point forecast['currently']['windBearing']} at #{forecast['currently']['windSpeed']} mph. " +
    "It will be #{minute_forecast}, and #{forecast['hourly']['summary'].to_s.downcase.chop}.  There are also #{forecast['currently']['ozone'].to_s} ozones."
    # daily.summary
  end

  def celcius(degreesF)
    (0.5555555556 * (degreesF.to_f - 32)).round(2)
  end

  def compass_point(bearing)
    case bearing
      when 0..25
        'N'
      when 26..65
        'NE'
      when 66..115
        'E'
      when 116..155
        'SE'
      when 156..205
        'S'
      when 206..245
        'SW'
      when 246..295
        'W'
      when 296..335
        'NW'
      when 336..360
        'N'
    end
  end
end

def seven_day(msg, query)
  forecast, long_name = get_forecast_io_results query

  mintemps = []
  maxtemps = []

  forecast['daily']['data'].each do |day|
    mintemps.push day['temperatureMin'].to_f.round(1)
    maxtemps.push day['temperatureMax'].to_f.round(1)
  end

  differential = maxtemps.max - maxtemps.min
  str = ''
  maxtemps.each do |t|
    str += get_dot (t - maxtemps.min) / differential, ansi_chars
  end

  msg.reply "7day high temps for #{long_name} #{maxtemps.first}°F |#{str}| #{maxtemps.last}°F"

  differential = mintemps.max - mintemps.min
  str = ''
  mintemps.each do |t|
    str += get_dot (t - mintemps.min) / differential, ansi_chars
  end

  msg.reply "7day loow temps for #{long_name} #{mintemps.first}°F |#{str}| #{mintemps.last}°F"
  #  / mins: #{mintemps.join ' '}
end

def alerts(msg, query)
  forecast, long_name = get_forecast_io_results query
  forecast['alerts'].each do |alert|
    msg.reply(long_name + ' ' + alert['uri'])
  end
end

x = <<-end
{
     "latitude": 45.5252,
     "longitude": -122.6751,
     "timezone": "America/Los_Angeles",
     "offset": -7,
     "currently": {
     "time": 1381347705,
     "summary": "Clear",
     "icon": "clear-day",
     "precipIntensity": 0,
     "precipProbability": 0,
     "temperature": 52.34,
     "apparentTemperature": 52.34,
     "dewPoint": 42.25,
     "windSpeed": 4.06,
     "windBearing": 7,
     "cloudCover": 0.2,
     "humidity": 0.68,
     "pressure": 1018.55,
     "visibility": 9.95,
     "ozone": 304.7
  },
      "minutely": {
      "summary": "Clear for the hour.",
      "icon": "clear-day",
      "data": [
      {
          "time": 1381347660,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381347720,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381347780,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381347840,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381347900,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381347960,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348020,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348080,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348140,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348200,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348260,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348320,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348380,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348440,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348500,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348560,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348620,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348680,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348740,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348800,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348860,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348920,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381348980,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349040,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349100,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349160,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349220,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349280,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349340,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349400,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349460,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349520,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349580,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349640,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349700,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349760,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349820,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349880,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381349940,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350000,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350060,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350120,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350180,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350240,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350300,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350360,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350420,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350480,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350540,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350600,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350660,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350720,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350780,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350840,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350900,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381350960,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381351020,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381351080,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381351140,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381351200,
      "precipIntensity": 0,
      "precipProbability": 0
  },
      {
          "time": 1381351260,
      "precipIntensity": 0,
      "precipProbability": 0
  }
  ]
  },
      "hourly": {
      "summary": "Mostly cloudy starting this evening.",
      "icon": "partly-cloudy-night",
      "data": [
      {
          "time": 1381345200,
      "summary": "Clear",
      "icon": "clear-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 51.17,
      "apparentTemperature": 51.17,
      "dewPoint": 42.24,
      "windSpeed": 3.23,
      "windBearing": 9,
      "cloudCover": 0.16,
      "humidity": 0.71,
      "pressure": 1019.02,
      "visibility": 9.92,
      "ozone": 304.9
  },
      {
          "time": 1381348800,
      "summary": "Clear",
      "icon": "clear-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 52.85,
      "apparentTemperature": 52.85,
      "dewPoint": 42.24,
      "windSpeed": 4.42,
      "windBearing": 6,
      "cloudCover": 0.22,
      "humidity": 0.67,
      "pressure": 1018.35,
      "visibility": 9.96,
      "ozone": 304.62
  },
      {
          "time": 1381352400,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 55.25,
      "apparentTemperature": 55.25,
      "dewPoint": 41.92,
      "windSpeed": 4.75,
      "windBearing": 7,
      "cloudCover": 0.27,
      "humidity": 0.61,
      "pressure": 1017.01,
      "visibility": 10,
      "ozone": 304.15
  },
      {
          "time": 1381356000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 57.47,
      "apparentTemperature": 57.47,
      "dewPoint": 41.31,
      "windSpeed": 5.32,
      "windBearing": 6,
      "cloudCover": 0.26,
      "humidity": 0.55,
      "pressure": 1015.42,
      "visibility": 10,
      "ozone": 303.39
  },
      {
          "time": 1381359600,
      "summary": "Clear",
      "icon": "clear-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 58.73,
      "apparentTemperature": 58.73,
      "dewPoint": 40.91,
      "windSpeed": 6.39,
      "windBearing": 6,
      "cloudCover": 0.17,
      "humidity": 0.52,
      "pressure": 1014.15,
      "visibility": 10,
      "ozone": 302.44
  },
      {
          "time": 1381363200,
      "summary": "Clear",
      "icon": "clear-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 59.09,
      "apparentTemperature": 59.09,
      "dewPoint": 41.27,
      "windSpeed": 7.16,
      "windBearing": 3,
      "cloudCover": 0.07,
      "humidity": 0.52,
      "pressure": 1011.82,
      "visibility": 10,
      "ozone": 301.6
  },
      {
          "time": 1381366800,
      "summary": "Clear",
      "icon": "clear-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 57.82,
      "apparentTemperature": 57.82,
      "dewPoint": 42.53,
      "windSpeed": 7.08,
      "windBearing": 5,
      "cloudCover": 0.11,
      "humidity": 0.57,
      "pressure": 1011.81,
      "visibility": 10,
      "ozone": 300.97
  },
      {
          "time": 1381370400,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 54.68,
      "apparentTemperature": 54.68,
      "dewPoint": 43.51,
      "windSpeed": 5.71,
      "windBearing": 5,
      "cloudCover": 0.29,
      "humidity": 0.66,
      "pressure": 1011.98,
      "visibility": 9.78,
      "ozone": 300.44
  },
      {
          "time": 1381374000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 52.14,
      "apparentTemperature": 52.14,
      "dewPoint": 43.81,
      "windSpeed": 4.77,
      "windBearing": 1,
      "cloudCover": 0.47,
      "humidity": 0.73,
      "pressure": 1012.13,
      "visibility": 9.49,
      "ozone": 299.92
  },
      {
          "time": 1381377600,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 50.5,
      "apparentTemperature": 50.5,
      "dewPoint": 43.53,
      "windSpeed": 4.02,
      "windBearing": 357,
      "cloudCover": 0.68,
      "humidity": 0.77,
      "pressure": 1012.19,
      "visibility": 9.38,
      "ozone": 298.66
  },
      {
          "time": 1381381200,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 49.27,
      "apparentTemperature": 48.61,
      "dewPoint": 43.1,
      "windSpeed": 3.26,
      "windBearing": 348,
      "cloudCover": 0.65,
      "humidity": 0.79,
      "pressure": 1012.2,
      "visibility": 9.32,
      "ozone": 297.41
  },
      {
          "time": 1381384800,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 48.21,
      "apparentTemperature": 48.21,
      "dewPoint": 42.66,
      "windSpeed": 2.63,
      "windBearing": 341,
      "cloudCover": 0.81,
      "humidity": 0.81,
      "pressure": 1012.17,
      "visibility": 9.25,
      "ozone": 298.34
  },
      {
          "time": 1381388400,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 47.76,
      "apparentTemperature": 47.76,
      "dewPoint": 42.35,
      "windSpeed": 2.29,
      "windBearing": 335,
      "cloudCover": 0.77,
      "humidity": 0.81,
      "pressure": 1012.11,
      "visibility": 9.25,
      "ozone": 303.75
  },
      {
          "time": 1381392000,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 47.27,
      "apparentTemperature": 47.27,
      "dewPoint": 42.13,
      "windSpeed": 2.14,
      "windBearing": 308,
      "cloudCover": 0.76,
      "humidity": 0.82,
      "pressure": 1012.02,
      "visibility": 9.27,
      "ozone": 311.35
  },
      {
          "time": 1381395600,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 46.5,
      "apparentTemperature": 46.5,
      "dewPoint": 41.81,
      "windSpeed": 2.5,
      "windBearing": 307,
      "cloudCover": 0.73,
      "humidity": 0.84,
      "pressure": 1011.89,
      "visibility": 9.3,
      "ozone": 316.49
  },
      {
          "time": 1381399200,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 45.9,
      "apparentTemperature": 45.9,
      "dewPoint": 41.54,
      "windSpeed": 2.36,
      "windBearing": 304,
      "cloudCover": 0.81,
      "humidity": 0.85,
      "pressure": 1011.65,
      "visibility": 9.29,
      "ozone": 316.69
  },
      {
          "time": 1381402800,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 45.03,
      "apparentTemperature": 45.03,
      "dewPoint": 40.96,
      "windSpeed": 2.19,
      "windBearing": 277,
      "cloudCover": 0.73,
      "humidity": 0.86,
      "pressure": 1011.38,
      "visibility": 9.28,
      "ozone": 314.43
  },
      {
          "time": 1381406400,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 44.24,
      "apparentTemperature": 44.24,
      "dewPoint": 40.84,
      "windSpeed": 2.15,
      "windBearing": 252,
      "cloudCover": 0.62,
      "humidity": 0.88,
      "pressure": 1011.23,
      "visibility": 9.25,
      "ozone": 312.44
  },
      {
          "time": 1381410000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 43.66,
      "apparentTemperature": 43.66,
      "dewPoint": 40.48,
      "windSpeed": 2.12,
      "windBearing": 221,
      "cloudCover": 0.57,
      "humidity": 0.88,
      "pressure": 1011.27,
      "visibility": 9.57,
      "ozone": 311.63
  },
      {
          "time": 1381413600,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 43.25,
      "apparentTemperature": 43.25,
      "dewPoint": 40.4,
      "windSpeed": 2.12,
      "windBearing": 194,
      "cloudCover": 0.55,
      "humidity": 0.9,
      "pressure": 1011.44,
      "visibility": 9.77,
      "ozone": 311.09
  },
      {
          "time": 1381417200,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 44.12,
      "apparentTemperature": 44.12,
      "dewPoint": 40.75,
      "windSpeed": 2.2,
      "windBearing": 177,
      "cloudCover": 0.56,
      "humidity": 0.88,
      "pressure": 1011.61,
      "visibility": 9.84,
      "ozone": 310.8
  },
      {
          "time": 1381420800,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 46.06,
      "apparentTemperature": 46.06,
      "dewPoint": 41.8,
      "windSpeed": 2.71,
      "windBearing": 187,
      "cloudCover": 0.59,
      "humidity": 0.85,
      "pressure": 1011.77,
      "visibility": 9.91,
      "ozone": 311.04
  },
      {
          "time": 1381424400,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 48.46,
      "apparentTemperature": 47.8,
      "dewPoint": 42.91,
      "windSpeed": 3.15,
      "windBearing": 209,
      "cloudCover": 0.64,
      "humidity": 0.81,
      "pressure": 1011.93,
      "visibility": 9.99,
      "ozone": 311.54
  },
      {
          "time": 1381428000,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 50.71,
      "apparentTemperature": 50.71,
      "dewPoint": 43.51,
      "windSpeed": 3.66,
      "windBearing": 220,
      "cloudCover": 0.7,
      "humidity": 0.76,
      "pressure": 1012.04,
      "visibility": 9.99,
      "ozone": 311.33
  },
      {
          "time": 1381431600,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 51.94,
      "apparentTemperature": 51.94,
      "dewPoint": 44.31,
      "windSpeed": 4.42,
      "windBearing": 231,
      "cloudCover": 0.79,
      "humidity": 0.75,
      "pressure": 1012.06,
      "visibility": 10,
      "ozone": 309.76
  },
      {
          "time": 1381435200,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 52.41,
      "apparentTemperature": 52.41,
      "dewPoint": 44.87,
      "windSpeed": 5.08,
      "windBearing": 247,
      "cloudCover": 0.86,
      "humidity": 0.75,
      "pressure": 1012.04,
      "visibility": 10,
      "ozone": 307.49
  },
      {
          "time": 1381438800,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0.00166,
      "precipProbability": 0.01,
      "precipType": "rain",
      "temperature": 53.1,
      "apparentTemperature": 53.1,
      "dewPoint": 45.8,
      "windSpeed": 5.42,
      "windBearing": 261,
      "cloudCover": 0.93,
      "humidity": 0.76,
      "pressure": 1012.04,
      "visibility": 10,
      "ozone": 305.61
  },
      {
          "time": 1381442400,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0.00147,
      "precipProbability": 0.01,
      "precipType": "rain",
      "temperature": 54.35,
      "apparentTemperature": 54.35,
      "dewPoint": 47.06,
      "windSpeed": 4.91,
      "windBearing": 265,
      "cloudCover": 0.91,
      "humidity": 0.76,
      "pressure": 1012.11,
      "visibility": 10,
      "ozone": 304.61
  },
      {
          "time": 1381446000,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0.00098,
      "precipProbability": 0.01,
      "precipType": "rain",
      "temperature": 55.48,
      "apparentTemperature": 55.48,
      "dewPoint": 48.23,
      "windSpeed": 3.7,
      "windBearing": 261,
      "cloudCover": 0.84,
      "humidity": 0.77,
      "pressure": 1012.25,
      "visibility": 10,
      "ozone": 303.99
  },
      {
          "time": 1381449600,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0.00057,
      "precipProbability": 0.01,
      "precipType": "rain",
      "temperature": 56.36,
      "apparentTemperature": 56.36,
      "dewPoint": 49.39,
      "windSpeed": 2.86,
      "windBearing": 262,
      "cloudCover": 0.77,
      "humidity": 0.77,
      "pressure": 1012.51,
      "visibility": 10,
      "ozone": 303.34
  },
      {
          "time": 1381453200,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 55.13,
      "apparentTemperature": 55.13,
      "dewPoint": 48.99,
      "windSpeed": 2.71,
      "windBearing": 264,
      "cloudCover": 0.73,
      "humidity": 0.8,
      "pressure": 1012.95,
      "visibility": 10,
      "ozone": 302.46
  },
      {
          "time": 1381456800,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 53.33,
      "apparentTemperature": 53.33,
      "dewPoint": 48.21,
      "windSpeed": 2.75,
      "windBearing": 267,
      "cloudCover": 0.7,
      "humidity": 0.83,
      "pressure": 1013.52,
      "visibility": 10,
      "ozone": 301.55
  },
      {
          "time": 1381460400,
      "summary": "Mostly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 51.88,
      "apparentTemperature": 51.88,
      "dewPoint": 47.62,
      "windSpeed": 2.85,
      "windBearing": 272,
      "cloudCover": 0.65,
      "humidity": 0.85,
      "pressure": 1014.12,
      "visibility": 10,
      "ozone": 300.82
  },
      {
          "time": 1381464000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 50.46,
      "apparentTemperature": 50.46,
      "dewPoint": 46.79,
      "windSpeed": 3.19,
      "windBearing": 283,
      "cloudCover": 0.54,
      "humidity": 0.87,
      "pressure": 1014.73,
      "visibility": 10,
      "ozone": 300.52
  },
      {
          "time": 1381467600,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 48.9,
      "apparentTemperature": 48,
      "dewPoint": 45.69,
      "windSpeed": 3.48,
      "windBearing": 297,
      "cloudCover": 0.4,
      "humidity": 0.89,
      "pressure": 1015.32,
      "visibility": 10,
      "ozone": 300.4
  },
      {
          "time": 1381471200,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 47.61,
      "apparentTemperature": 46.53,
      "dewPoint": 44.78,
      "windSpeed": 3.48,
      "windBearing": 303,
      "cloudCover": 0.29,
      "humidity": 0.9,
      "pressure": 1015.8,
      "visibility": 10,
      "ozone": 299.94
  },
      {
          "time": 1381474800,
      "summary": "Clear",
      "icon": "clear-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 46.61,
      "apparentTemperature": 45.65,
      "dewPoint": 44.1,
      "windSpeed": 3.2,
      "windBearing": 293,
      "cloudCover": 0.22,
      "humidity": 0.91,
      "pressure": 1016.12,
      "visibility": 10,
      "ozone": 298.77
  },
      {
          "time": 1381478400,
      "summary": "Clear",
      "icon": "clear-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 45.72,
      "apparentTemperature": 45.72,
      "dewPoint": 43.49,
      "windSpeed": 2.79,
      "windBearing": 272,
      "cloudCover": 0.18,
      "humidity": 0.92,
      "pressure": 1016.35,
      "visibility": 10,
      "ozone": 297.26
  },
      {
          "time": 1381482000,
      "summary": "Clear",
      "icon": "clear-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 44.93,
      "apparentTemperature": 44.93,
      "dewPoint": 42.87,
      "windSpeed": 2.4,
      "windBearing": 258,
      "cloudCover": 0.19,
      "humidity": 0.92,
      "pressure": 1016.55,
      "visibility": 10,
      "ozone": 296
  },
      {
          "time": 1381485600,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 44.24,
      "apparentTemperature": 44.24,
      "dewPoint": 42.23,
      "windSpeed": 2.1,
      "windBearing": 247,
      "cloudCover": 0.26,
      "humidity": 0.93,
      "pressure": 1016.74,
      "visibility": 10,
      "ozone": 295.3
  },
      {
          "time": 1381489200,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 43.65,
      "apparentTemperature": 43.65,
      "dewPoint": 41.6,
      "windSpeed": 1.87,
      "windBearing": 235,
      "cloudCover": 0.37,
      "humidity": 0.92,
      "pressure": 1016.93,
      "visibility": 10,
      "ozone": 294.84
  },
      {
          "time": 1381492800,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 43.19,
      "apparentTemperature": 43.19,
      "dewPoint": 41.06,
      "windSpeed": 1.74,
      "windBearing": 231,
      "cloudCover": 0.44,
      "humidity": 0.92,
      "pressure": 1017.15,
      "visibility": 10,
      "ozone": 294.26
  },
      {
          "time": 1381496400,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 42.77,
      "apparentTemperature": 42.77,
      "dewPoint": 40.74,
      "windSpeed": 1.69,
      "windBearing": 225,
      "cloudCover": 0.42,
      "humidity": 0.92,
      "pressure": 1017.46,
      "visibility": 10,
      "ozone": 293.35
  },
      {
          "time": 1381500000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-night",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 42.27,
      "apparentTemperature": 42.27,
      "dewPoint": 40.31,
      "windSpeed": 1.71,
      "windBearing": 203,
      "cloudCover": 0.35,
      "humidity": 0.93,
      "pressure": 1017.8,
      "visibility": 10,
      "ozone": 292.31
  },
      {
          "time": 1381503600,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 42.5,
      "apparentTemperature": 42.5,
      "dewPoint": 40.01,
      "windSpeed": 1.76,
      "windBearing": 196,
      "cloudCover": 0.31,
      "humidity": 0.91,
      "pressure": 1018.1,
      "visibility": 10,
      "ozone": 291.38
  },
      {
          "time": 1381507200,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 44.75,
      "apparentTemperature": 44.75,
      "dewPoint": 40.62,
      "windSpeed": 1.67,
      "windBearing": 187,
      "cloudCover": 0.31,
      "humidity": 0.85,
      "pressure": 1018.36,
      "visibility": 10,
      "ozone": 290.62
  },
      {
          "time": 1381510800,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 48.12,
      "apparentTemperature": 48.12,
      "dewPoint": 41.54,
      "windSpeed": 1.58,
      "windBearing": 179,
      "cloudCover": 0.32,
      "humidity": 0.78,
      "pressure": 1018.56,
      "visibility": 10,
      "ozone": 289.96
  },
      {
          "time": 1381514400,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 51.17,
      "apparentTemperature": 51.17,
      "dewPoint": 42.13,
      "windSpeed": 1.9,
      "windBearing": 167,
      "cloudCover": 0.37,
      "humidity": 0.71,
      "pressure": 1018.58,
      "visibility": 10,
      "ozone": 289.47
  },
      {
          "time": 1381518000,
      "summary": "Partly Cloudy",
      "icon": "partly-cloudy-day",
      "precipIntensity": 0,
      "precipProbability": 0,
      "temperature": 53.45,
      "apparentTemperature": 53.45,
      "dewPoint": 42.19,
      "windSpeed": 2.94,
      "windBearing": 149,
      "cloudCover": 0.49,
      "humidity": 0.66,
      "pressure": 1018.27,
      "visibility": 10,
      "ozone": 289.05
  }
  ]
  },
      "daily": {
      "summary": "No precipitation for the week; temperatures rising to 68° on Tuesday.",
      "icon": "clear-day",
      "data": [
      {
          "time": 1381302000,
      "summary": "Partly cloudy throughout the day.",
      "icon": "partly-cloudy-day",
      "sunriseTime": 1381328445,
      "sunsetTime": 1381369034,
      "precipIntensity": 0.00009,
      "precipIntensityMax": 0,
      "precipProbability": 0.78,
      "precipType": "rain",
      "temperatureMin": 40.14,
      "temperatureMinTime": 1381320000,
      "temperatureMax": 59.09,
      "temperatureMaxTime": 1381363200,
      "apparentTemperatureMin": 40.14,
      "apparentTemperatureMinTime": 1381320000,
      "apparentTemperatureMax": 59.09,
      "apparentTemperatureMaxTime": 1381363200,
      "dewPoint": 41.12,
      "windSpeed": 3.66,
      "windBearing": 17,
      "cloudCover": 0.46,
      "humidity": 0.79,
      "pressure": 1016.21,
      "visibility": 8.85,
      "ozone": 303.79
  },
      {
          "time": 1381388400,
      "summary": "Mostly cloudy throughout the day.",
      "icon": "partly-cloudy-day",
      "sunriseTime": 1381414923,
      "sunsetTime": 1381455324,
      "precipIntensity": 0.00035,
      "precipIntensityMax": 0,
      "precipProbability": 0.01,
      "precipType": "rain",
      "temperatureMin": 43.25,
      "temperatureMinTime": 1381413600,
      "temperatureMax": 56.36,
      "temperatureMaxTime": 1381449600,
      "apparentTemperatureMin": 43.25,
      "apparentTemperatureMinTime": 1381413600,
      "apparentTemperatureMax": 56.36,
      "apparentTemperatureMaxTime": 1381449600,
      "dewPoint": 44.22,
      "windSpeed": 3.1,
      "windBearing": 260,
      "cloudCover": 0.68,
      "humidity": 0.83,
      "pressure": 1012.49,
      "visibility": 9.78,
      "ozone": 307.63
  },
      {
          "time": 1381474800,
      "summary": "Mostly cloudy throughout the day.",
      "icon": "partly-cloudy-day",
      "sunriseTime": 1381501401,
      "sunsetTime": 1381541614,
      "precipIntensity": 0,
      "precipIntensityMax": 0,
      "precipProbability": 0,
      "temperatureMin": 42.27,
      "temperatureMinTime": 1381500000,
      "temperatureMax": 58.66,
      "temperatureMaxTime": 1381532400,
      "apparentTemperatureMin": 42.27,
      "apparentTemperatureMinTime": 1381500000,
      "apparentTemperatureMax": 58.66,
      "apparentTemperatureMaxTime": 1381532400,
      "dewPoint": 42.53,
      "windSpeed": 3.21,
      "windBearing": 275,
      "cloudCover": 0.57,
      "humidity": 0.77,
      "pressure": 1017.43,
      "visibility": 10,
      "ozone": 294.09
  },
      {
          "time": 1381561200,
      "summary": "Clear throughout the day.",
      "icon": "clear-day",
      "sunriseTime": 1381587879,
      "sunsetTime": 1381627905,
      "precipIntensity": 0.00052,
      "precipIntensityMax": 0,
      "precipProbability": 0.05,
      "precipType": "rain",
      "temperatureMin": 41.75,
      "temperatureMinTime": 1381586400,
      "temperatureMax": 60.87,
      "temperatureMaxTime": 1381618800,
      "apparentTemperatureMin": 39.65,
      "apparentTemperatureMinTime": 1381586400,
      "apparentTemperatureMax": 60.87,
      "apparentTemperatureMaxTime": 1381618800,
      "dewPoint": 42.06,
      "windSpeed": 4.72,
      "windBearing": 338,
      "cloudCover": 0.16,
      "humidity": 0.72,
      "pressure": 1018.4,
      "visibility": 10,
      "ozone": 308.29
  },
      {
          "time": 1381647600,
      "summary": "Clear throughout the day.",
      "icon": "clear-day",
      "sunriseTime": 1381674358,
      "sunsetTime": 1381714197,
      "precipIntensity": 0,
      "precipIntensityMax": 0,
      "precipProbability": 0,
      "temperatureMin": 38.87,
      "temperatureMinTime": 1381669200,
      "temperatureMax": 64.04,
      "temperatureMaxTime": 1381705200,
      "apparentTemperatureMin": 38.87,
      "apparentTemperatureMinTime": 1381669200,
      "apparentTemperatureMax": 64.04,
      "apparentTemperatureMaxTime": 1381705200,
      "dewPoint": 44.12,
      "windSpeed": 2.68,
      "windBearing": 26,
      "cloudCover": 0.01,
      "humidity": 0.81,
      "pressure": 1024.08,
      "ozone": 279.16
  },
      {
          "time": 1381734000,
      "summary": "Clear throughout the day.",
      "icon": "clear-day",
      "sunriseTime": 1381760838,
      "sunsetTime": 1381800490,
      "precipIntensity": 0,
      "precipIntensityMax": 0,
      "precipProbability": 0,
      "temperatureMin": 39.57,
      "temperatureMinTime": 1381755600,
      "temperatureMax": 67.86,
      "temperatureMaxTime": 1381791600,
      "apparentTemperatureMin": 36.96,
      "apparentTemperatureMinTime": 1381755600,
      "apparentTemperatureMax": 67.86,
      "apparentTemperatureMaxTime": 1381791600,
      "dewPoint": 42.51,
      "windSpeed": 4.08,
      "windBearing": 65,
      "cloudCover": 0,
      "humidity": 0.69,
      "pressure": 1023.02,
      "ozone": 264.64
  },
      {
          "time": 1381820400,
      "summary": "Partly cloudy overnight.",
      "icon": "partly-cloudy-night",
      "sunriseTime": 1381847317,
      "sunsetTime": 1381886783,
      "precipIntensity": 0.00059,
      "precipIntensityMax": 0,
      "precipProbability": 0.1,
      "precipType": "rain",
      "temperatureMin": 43.48,
      "temperatureMinTime": 1381845600,
      "temperatureMax": 68.24,
      "temperatureMaxTime": 1381878000,
      "apparentTemperatureMin": 40.74,
      "apparentTemperatureMinTime": 1381845600,
      "apparentTemperatureMax": 68.24,
      "apparentTemperatureMaxTime": 1381878000,
      "dewPoint": 43.64,
      "windSpeed": 4.16,
      "windBearing": 78,
      "cloudCover": 0.02,
      "humidity": 0.66,
      "pressure": 1021.23,
      "ozone": 262.76
  },
      {
          "time": 1381906800,
      "summary": "Partly cloudy throughout the day.",
      "icon": "partly-cloudy-day",
      "sunriseTime": 1381933797,
      "sunsetTime": 1381973078,
      "precipIntensity": 0.00068,
      "precipIntensityMax": 0,
      "precipProbability": 0.12,
      "precipType": "rain",
      "temperatureMin": 45,
      "temperatureMinTime": 1381932000,
      "temperatureMax": 69.41,
      "temperatureMaxTime": 1381964400,
      "apparentTemperatureMin": 43.07,
      "apparentTemperatureMinTime": 1381932000,
      "apparentTemperatureMax": 69.41,
      "apparentTemperatureMaxTime": 1381964400,
      "dewPoint": 45.42,
      "windSpeed": 3.29,
      "windBearing": 66,
      "cloudCover": 0.28,
      "humidity": 0.68,
      "pressure": 1021.31,
      "ozone": 265.78
  }
  ]
  },
      "flags": {
      "sources": [
      "isd",
      "fnmoc",
      "sref",
      "rtma",
      "rap",
      "nam",
      "cmc",
      "gfs",
      "lamp",
      "metar",
      "nwspa",
      "darksky"
  ],
      "isd-stations": [
      "726980-24229",
      "727918-94298",
      "727918-99999",
      "999999-24229",
      "999999-24274"
  ],
      "lamp-stations": [
      "KPDX",
      "KUAO",
      "KVUO"
  ],
      "metar-stations": [
      "KPDX",
      "KUAO",
      "KVUO"
  ],
      "darksky-stations": [
      "KRTX"
  ],
      "units": "us"
  }
}

{
    results: [
        {
            address_components: [
                {
                    long_name: "97206",
                    short_name: "97206",
                    types: [
                        "postal_code"
                    ]
                },
                {
                    long_name: "Portland",
                    short_name: "Portland",
                    types: [
                        "locality",
                        "political"
                    ]
                },
                {
                    long_name: "Oregon",
                    short_name: "OR",
                    types: [
                        "administrative_area_level_1",
                        "political"
                    ]
                },
                {
                    long_name: "Stati Uniti",
                    short_name: "US",
                    types: [
                        "country",
                        "political"
                    ]
                }
            ],
            formatted_address: "Portland, Oregon 97206, Stati Uniti",
            geometry: {
                bounds: {
                    northeast: {
                        lat: 45.5089909,
                        lng: -122.578679
                    },
                    southwest: {
                        lat: 45.455264,
                        lng: -122.620776
                    }
                },
                location: {
                    lat: 45.48563720000001,
                    lng: -122.5946256
                },
                location_type: "APPROXIMATE",
                viewport: {
                    northeast: {
                        lat: 45.5089909,
                        lng: -122.578679
                    },
                    southwest: {
                        lat: 45.455264,
                        lng: -122.620776
                    }
                }
            },
            types: [
                "postal_code"
            ]
        }
    ],
    status: "OK"
}
end
