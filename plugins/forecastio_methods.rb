module ForecastIOMethods

  def key
    'weather'
  end

  def scale
    'f'
  end

  def ansi_chars
    %w[_ ▁ ▃ ▅ ▇ █]
  end

  def ozone_chars
    %w[・ o O @ ◎ ◉]
  end

  def ascii_chars
    %w[_ . - • * ']
  end

  # !weather
  def execute(msg, command, query)
    secondary_command = nil

    # Put here a list of all secondary commands.
    if query.match /^(intensity|dir|set)\s*/
      secondary_command = $1
      query.gsub! /^#{$1}\s*/, ''
    end

    if secondary_command == 'set'
      # We're really setting this here, but hey.
      (setting, value) = query.downcase.split /\s+/
      if setting == 'scale' and (value == 'f' or value == 'c')
        get_personalized_query(msg.user.name,   key + "_#{setting}", value)
        msg.reply "#{msg.user.nick}: Temperature scale set to #{value}"
        return
      end
    else
      @scale = get_personalized_query(msg.user.name, key + "_scale", '')
    end

    query = get_personalized_query(msg.user.name, key, query)
    forecast = get_forecast_io_results query

    case command
      when 'forecast', 'weather', 'asciithefuckingweather'
        str = get_weather_forecast forecast
      when 'asciirain', 'asciisnow'
        if secondary_command == 'intensity'
          str = ascii_rain_intensity_forecast forecast
        else
          str = ascii_rain_forecast forecast
        end
      when 'ansirain', 'ansisnow'
        if secondary_command == 'intensity'
          str = ansi_rain_intensity_forecast forecast
        else
          str = ansi_rain_forecast forecast
        end
      when 'asciiozone'
        str = ascii_ozone_forecast forecast
      when 'asciitemp'
        str = ascii_temp_forecast forecast
      when 'ansitemp'
        str = ansi_temp_forecast forecast
      when 'asciiwind'
        if secondary_command == 'dir'
          str = ansi_wind_direction_forecast forecast
        else
          str = ascii_wind_forecast forecast
        end
      when 'ansiwind'
        if secondary_command == 'dir'
          str = ansi_wind_direction_forecast forecast
        else
          str = ansi_wind_forecast forecast
        end
      when 'winddir'
        str = ansi_wind_direction_forecast forecast
      when 'asciisun'
        str = ascii_sun_forecast forecast
      when 'ansisun'
        str = ansi_sun_forecast forecast
      when '7day'
        str = seven_day forecast
      when 'alerts'
        str = alerts forecast
    end
    msg.reply "#{forecast['long_name']} #{str}"  if str
  end

  def get_weather_forecast(forecast)
    format_forecast_message forecast
  end

# ▁▃▅▇█▇▅▃▁ agj
  def ascii_rain_forecast(forecast)
    do_the_rain_chance_thing(forecast, ascii_chars, 'precipProbability', 'probability')
  end

  def ansi_rain_forecast(forecast)
    do_the_rain_chance_thing(forecast, ansi_chars, 'precipProbability', 'probability')
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
  end

  def ascii_rain_intensity_forecast(forecast)
    do_the_rain_chance_thing(forecast, ascii_chars, 'precipIntensity', 'intensity')
  end

  def ansi_rain_intensity_forecast(forecast)
    do_the_rain_chance_thing(forecast, ansi_chars, 'precipIntensity', 'intensity')
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
  end

  def do_the_rain_chance_thing(forecast, chars, key, type)
    precip_type = 'rain'
    data_points = []
    data = forecast['minutely']['data']

    data.each do |datum|
      data_points.push datum[key]
      precip_type = 'snow' if datum['precipType'] == 'snow'
    end

    if precip_type = 'snow' and type != 'intensity'
      chars = %w[_ ☃ ☃ ☃ ☃ ☃] # Hat tip to hallettj@#pdxtech
    end

    differential = data_points.max - data_points.min

    str = get_dot_str(chars, data, data_points.min, differential, key)
    #  - 28800
    "#{precip_type} #{type} #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def ascii_ozone_forecast(forecast)
    # O ◎ ]
    data = forecast['hourly']['data']

    str = get_dot_str(@ozone_chars, data, 280, 350-280, 'ozone')

    "ozones #{data.first['ozone']} |#{str}| #{data.last['ozone']} [24h forecast]"
  end

  def ascii_temp_forecast(forecast)
    do_the_temp_thing(forecast, ascii_chars)
  end

  def ansi_temp_forecast(forecast)
    do_the_temp_thing(forecast, ansi_chars, true)
  end

  def do_the_temp_thing(forecast, chars, ansi = false)
    temps = []
    data = forecast['hourly']['data']
    data_limited = []

    data.each_with_index do |datum, index|
      temps.push datum['temperature']
      data_limited.push datum
      break if index == 23 # We only want 24hrs of data.
    end

    differential = temps.max - temps.min

    # Hmm.  There's a better way.
    if ansi
      str = get_ansitemp_dot_str(chars, data_limited, temps.min, differential, 'temperature')
    else
      str = get_dot_str(chars, data_limited, temps.min, differential, 'temperature')
    end

    "temps: now #{get_temperature data.first['temperature'].round(1)} |#{str}| #{get_temperature data.last['temperature'].round(1)} this hour tomorrow.  Range: #{get_temperature temps.min.round(1)} - #{get_temperature temps.max.round(1)}"
  end

  def format_forecast_message(forecast)
    minute_forecast = forecast['minutely']['summary'].to_s.downcase.chop if forecast['minutely']
    "weather is currently #{get_temperature forecast['currently']['temperature']} " +
        "and #{forecast['currently']['summary'].downcase}.  Winds out of the #{get_cardinal_direction_from_bearing forecast['currently']['windBearing']} at #{forecast['currently']['windSpeed']} mph. " +
        "It will be #{minute_forecast}, and #{forecast['hourly']['summary'].to_s.downcase.chop}.  There are also #{forecast['currently']['ozone'].to_s} ozones."
    # daily.summary
  end

  def ascii_wind_forecast(forecast)
    do_the_wind_thing(forecast, ascii_chars)
  end

  def ansi_wind_forecast(forecast)
    do_the_wind_thing(forecast, ansi_chars)
  end

  def ansi_wind_direction_forecast(forecast)
    do_the_wind_direction_thing(forecast)
  end

  def do_the_wind_thing(forecast, chars)
    key = 'windSpeed'
    data_points = []
    data = forecast['hourly']['data']

    data.each do |datum|
      data_points.push datum[key]
    end

    differential = data_points.max - data_points.min
    str = get_wind_dot_str(chars, data, data_points.min, differential, key)

    "24h wind speed #{data.first['windSpeed']} mph |#{str}| #{data.last['windSpeed']} mph  Range: #{data_points.min} - #{data_points.max} mph"
  end

  def do_the_wind_direction_thing(forecast)
    key = 'windBearing'
    data = forecast['hourly']['data']
    str = ''
    # This is a little weird, because the arrows are 180° rotated.  That's because the wind bearing is "out of the N" not "towards the N".
    wind_arrows = {'N' => '↓', 'NE' => '↙', 'E' => '←', 'SE' => '↖', 'S' => '↑', 'SW' => '↗', 'W' => '→', 'NW' => '↘'}

    data.each do |datum|
      str += Format(get_wind_color(datum['windSpeed']), wind_arrows[get_cardinal_direction_from_bearing datum[key]])
    end

    "24h wind direction |#{str}|"
  end

  def ascii_sun_forecast(forecast)
    do_the_sun_thing(forecast, ascii_chars)
  end

  def ansi_sun_forecast(forecast)
    do_the_sun_thing(forecast, ansi_chars)
  end

  def do_the_sun_thing(forecast, chars)
    key = 'cloudCover'
    data_points = []
    data = forecast['daily']['data']

    data.each do |datum|
      data_points.push (1 - datum[key]).to_f  # It's a cloud cover percentage, so let's inverse it to give us sun cover.
      datum[key] = (1 - datum[key]).to_f      # Mod the source data for the get_dot_str call below.
    end

    differential = data_points.max - data_points.min
    str = get_dot_str(chars, data, data_points.min, differential, key)

    "7 day sun forecast |#{str}|"
  end

  def seven_day(forecast)
    mintemps = []
    maxtemps = []

    data = forecast['daily']['data']
    data.each do |day|
      mintemps.push day['temperatureMin']
      maxtemps.push day['temperatureMax']
    end

    differential = maxtemps.max - maxtemps.min
    max_str = get_dot_str(ansi_chars, data, maxtemps.min, differential, 'temperatureMax')

    differential = mintemps.max - mintemps.min
    min_str = get_dot_str(ansi_chars, data, mintemps.min, differential, 'temperatureMin')

    "7day high/low temps #{get_temperature maxtemps.first.to_f.round(1)} |#{max_str}| #{get_temperature maxtemps.last.to_f.round(1)} / #{get_temperature mintemps.first.to_f.round(1)} |#{min_str}| #{get_temperature mintemps.last.to_f.round(1)} Range: #{get_temperature mintemps.min} - #{get_temperature maxtemps.max}"
  end

  def alerts(forecast)
    str = ''
    if forecast['alerts']
      forecast['alerts'].each do |alert|
        alert['description'].match /\.\.\.(\w+)\.\.\./
        str += "#{shorten_url(alert['uri'])}#{$1}\n"
      end
    end
    str
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
    forecast['long_name'] = long_name   # Hacking the location into the hash.
    forecast
  end

  def get_dot_str(chars, data, min, differential, key)
    str = ''
    data.each do |datum|
      percentage = get_percentage(datum[key], differential, min)
      str += get_dot(percentage, chars)
    end
    str
  end

#  aqua
#  black
#  blue
#  brown
#  green
#  grey
#  lime
#  orange
#  pink
#  purple
#  red
#  royal
#  silver
#  teal
#  white
#  yellow
  def get_temp_color(temp)
    case temp
      # Absolute zero?  Sure, we support that!
      when -459.7..24.99
        :blue
      when 25..31.99
        :purple
      when 32..38
        :teal
      when 38..45
        :green
      when 45..55
        :lime
      when 55..65
        :aqua
      when 65..75
        :yellow
      when 75..85
        :orange
      when 85..95
        :red
      when 95..159.3
        :pink
      else
        :pink #wha
    end
  end

  def get_wind_color(speed)
    case speed
      when 0..3
        :blue
      when 3..6
        :purple
      when 6..9
        :teal
      when 9..12
        :aqua
      when 12..15
        :yellow
      when 15..18
        :orange
      when 18..21
        :red
      when 21..999
        :pink
      else
        :pink #wha
    end
  end

  def get_ansitemp_dot_str(chars, data, min, differential, key)
    str = ''
    data.each do |datum|
      color = get_temp_color datum[key]
      percentage = get_percentage(datum[key], differential, min)
      str += Format(color, get_dot(percentage, chars))
    end
    str
  end

  def get_wind_dot_str(chars, data, min, differential, key)
    str = ''
    data.each do |datum|
      color = get_wind_color datum[key]
      percentage = get_percentage(datum[key], differential, min)
      str += Format(color, get_dot(percentage, chars))
    end
    str
  end

  def get_percentage(number, differential, min)
    if differential == 0
      percentage = 0
    else
      percentage = (number.to_f - min) / (differential)
    end
    percentage
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

  def determine_intensity(query)
    if query =~ /^intensity/
      query = query.gsub /^intensity\s*/, ''
      key = 'precipIntensity'
    else
      key = 'precipProbability'
    end
    return query, key
  end

  def get_temperature(temp_f)
    if @scale == 'c'
      celcius(temp_f).to_s + '°C'
    else
      temp_f.to_s + '°F'
    end
  end

  def celcius(degreesF)
    (0.5555555556 * (degreesF.to_f - 32)).round(2)
  end

  def get_cardinal_direction_from_bearing(bearing)
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
