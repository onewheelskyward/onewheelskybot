require 'cinch/test'
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
    %w[_ . - ~ * ']
  end

  def get_rain_range_colors
    { 0..0.10    => :blue,
      0.11..0.20 => :purple,
      0.21..0.30 => :teal,
      0.31..0.40 => :green,
      0.41..0.50 => :lime,
      0.51..0.60 => :aqua,
      0.61..0.70 => :yellow,
      0.71..0.80 => :orange,
      0.81..0.90 => :red,
      0.91..1    => :pink
    }
  end

  def get_rain_intensity_range_colors
    { 0..0.0050      => :blue,
      0.0051..0.0100 => :purple,
      0.0101..0.0130 => :teal,
      0.0131..0.0170 => :green,
      0.0171..0.0220 => :lime,
      0.0221..0.0280 => :aqua,
      0.0281..0.0330 => :yellow,
      0.0331..0.0380 => :orange,
      0.0381..0.0430 => :red,
      0.0431..1      => :pink
    }
  end

  def get_temp_range_colors
    # Absolute zero?  You never know.
    { -459.7..24.99 => :blue,
      25..31.99     => :purple,
      32..38        => :teal,
      38..45        => :green,
      45..55        => :lime,
      55..65        => :aqua,
      65..75        => :yellow,
      75..85        => :orange,
      85..95        => :red,
      95..159.3     => :pink
    }
  end

  def get_wind_range_colors
    {   0..3    => :blue,
        3..6    => :purple,
        6..9    => :teal,
        9..12   => :aqua,
        12..15  => :yellow,
        15..18  => :orange,
        18..21  => :red,
        21..999 => :pink,
    }
  end

  def get_sun_range_colors
    { 0..0.20    => :green,
      0.21..0.50 => :lime,
      0.51..0.70 => :orange,
      0.71..1 => :yellow
    }
  end

  # !weather
  def execute(msg, command, query)
    secondary_command = nil
    username = (msg.user.nil?)? '' : msg.user.name

    # Put here a list of all secondary commands.
    if query.match /^(intensity|dir|set)\s*/
      secondary_command = $1
      query.gsub! /^#{$1}\s*/, ''
    end

    if secondary_command == 'set'
      # We're really setting this here, but hey.
      (setting, value) = query.downcase.split /\s+/
      if setting == 'scale' and (value == 'f' or value == 'c')
        get_personalized_query(username,   key + "_#{setting}", value)
        msg.reply "#{username}: Temperature scale set to #{value}"
        return
      end
    else
      @scale = get_personalized_query(username, key + "_scale", '')
    end

    query = get_personalized_query(username, key, query)
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
      when 'dailyrain'
        if secondary_command == 'intensity'
          str = daily_rain_intensity_forecast forecast
        else
          str = daily_rain_forecast forecast
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
      when /condi*t*i*o*n*s*/i
        str = conditions forecast

    end
    unless str.empty?
      msg.reply "#{forecast['long_name']} #{str}"
    end
  end

  def get_weather_forecast(forecast)
    format_forecast_message forecast
  end

# ▁▃▅▇█▇▅▃▁ agj
  def ascii_rain_forecast(forecast)
    str = do_the_rain_chance_thing(forecast, ascii_chars, 'precipProbability', 'probability', get_rain_range_colors)
    "rain probability #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def ansi_rain_forecast(forecast)
    str = do_the_rain_chance_thing(forecast, ansi_chars, 'precipProbability', 'probability', get_rain_range_colors)
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
    "rain probability #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def daily_rain_forecast(forecast)
    str = do_the_daily_rain_chance_thing(forecast, ansi_chars, 'precipProbability', 'probability', get_rain_range_colors)
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
    "rain probability now |#{str}| this hour tomorrow"
  end

  def daily_rain_intensity_forecast(forecast)
    str = do_the_daily_rain_chance_thing(forecast, ansi_chars, 'precipIntensity', 'intensity', get_rain_intensity_range_colors)
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
    "rain intensity now |#{str}| this hour tomorrow"
  end

  def ascii_rain_intensity_forecast(forecast)
    str = do_the_rain_chance_thing(forecast, ascii_chars, 'precipIntensity', 'intensity', get_rain_intensity_range_colors)
    "rain intensity #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def ansi_rain_intensity_forecast(forecast)
    str = do_the_rain_chance_thing(forecast, ansi_chars, 'precipIntensity', 'intensity', get_rain_intensity_range_colors)
    #msg.reply "|#{str}|  min-by-min rain prediction.  range |▁▃▅▇█▇▅▃▁| art by 'a-g-j' =~ s/-//g"
    "rain intensity #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def sms_rain_forecast(location)
    forecast = get_forecast_io_results location
    str = do_the_rain_chance_thing(forecast, ansi_chars, 'precipProbability', 'probability')
    "#{precip_type} #{type} #{(Time.now).strftime('%H:%M').to_s}|#{str}|#{(Time.now + 3600).strftime('%H:%M').to_s}"  #range |_.-•*'*•-._|
  end

  def do_the_rain_chance_thing(forecast, chars, key, type, range_colors = nil)
    precip_type = 'rain'
    data_points = []
    data = forecast['minutely']['data']

    data.each do |datum|
      data_points.push datum[key]
      precip_type = 'snow' if datum['precipType'] == 'snow'
    end

    if precip_type == 'snow' and type != 'intensity'
      chars = %w[_ ☃ ☃ ☃ ☃ ☃] # Hat tip to hallettj@#pdxtech
    end

    differential = data_points.max - data_points.min

    str = get_dot_str(chars, data, data_points.min, differential, key)

    if range_colors
      str = get_colored_string(data, key, str, range_colors)
    end
    #  - 28800
    return str
  end

  def do_the_daily_rain_chance_thing(forecast, chars, key, type, range_colors = nil)
    precip_type = 'rain'
    data_points = []
    data = forecast['hourly']['data']
    partial_data = []

    data.each_with_index do |datum, index|
      partial_data.push datum
      break if index == 23
    end

    partial_data.each_with_index do |datum, index|
      data_points.push datum[key]
      precip_type = 'snow' if datum['precipType'] == 'snow'
      break if index == 23
    end

    if precip_type == 'snow' and type != 'intensity'
      chars = %w[_ ☃ ☃ ☃ ☃ ☃] # Hat tip to hallettj@#pdxtech
    end

    differential = data_points.max - data_points.min

    str = get_dot_str(chars, partial_data, data_points.min, differential, key)

    if range_colors
      str = get_colored_string(partial_data, key, str, range_colors)
    end
    #  - 28800
    return str
  end

  def ascii_ozone_forecast(forecast)
    # O ◎ ]
    data = forecast['hourly']['data']

    str = get_dot_str(ozone_chars, data, 280, 350-280, 'ozone')

    "ozones #{data.first['ozone']} |#{str}| #{data.last['ozone']} [24h forecast]"
  end

  def ascii_temp_forecast(forecast, hours = 24)
    str, temperature_data = do_the_temp_thing(forecast, ascii_chars, hours)
    "temps: now #{get_temperature temperature_data.first.round(1)} |#{str}| #{get_temperature temperature_data.last.round(1)} this hour tomorrow.  Range: #{get_temperature temperature_data.min.round(1)} - #{get_temperature temperature_data.max.round(1)}"
  end

  def ansi_temp_forecast(forecast, hours = 24)
    str, temperature_data = do_the_temp_thing(forecast, ansi_chars, hours)
    "temps: now #{get_temperature temperature_data.first.round(1)} |#{str}| #{get_temperature temperature_data.last.round(1)} this hour tomorrow.  Range: #{get_temperature temperature_data.min.round(1)} - #{get_temperature temperature_data.max.round(1)}"
  end

  def do_the_temp_thing(forecast, chars, hours)
    temps = []
    data = forecast['hourly']['data']
    data_limited = []
    key = 'temperature'

    data.each_with_index do |datum, index|
      temps.push datum[key]
      data_limited.push datum
      break if index == hours - 1 # We only want (hours) 24hrs of data.
    end

    differential = temps.max - temps.min

    # Hmm.  There's a better way.
    dot_str = get_dot_str(chars, data_limited, temps.min, differential, key)

    temp_range_colors = get_temp_range_colors
    colored_str = get_colored_string(data_limited, key, dot_str, temp_range_colors)

    return colored_str, temps
  end

  def get_colored_string(data_limited, key, dot_str, range_hash)
    color = nil
    prev_color = nil
    collect_str = ''
    colored_str = ''

    data_limited.each_with_index do |data, index|
      range_hash.keys.each do |range_hash_key|
        if range_hash_key.cover? data[key]
          color = range_hash[range_hash_key]
          if index == 0
            prev_color = color
          end
        end
      end

      unless color == prev_color
        colored_str += Format(prev_color, collect_str)
        collect_str = ''
      end

      collect_str += dot_str[index]
      prev_color = color
    end

    colored_str += Format(color, collect_str)
    colored_str
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
    str, data = do_the_wind_direction_thing(forecast)
    "24h wind direction |#{str}| Range: #{data.min} - #{data.max} mph"
  end

  def do_the_wind_thing(forecast, chars)
    key = 'windSpeed'
    data_points = []
    data = forecast['hourly']['data']

    data.each do |datum|
      data_points.push datum[key]
    end

    differential = data_points.max - data_points.min
    str = get_dot_str(chars, data, data_points.min, differential, key)

    colored_str = get_colored_string(data, key, str, get_wind_range_colors)

    "24h wind speed #{data.first['windSpeed']} mph |#{colored_str}| #{data.last['windSpeed']} mph  Range: #{data_points.min} - #{data_points.max} mph"
  end

  def do_the_wind_direction_thing(forecast, hours = 24)
    key = 'windBearing'
    data = forecast['hourly']['data']
    str = ''
    data_points = []
    data_limited = []
    # This is a little weird, because the arrows are 180° rotated.  That's because the wind bearing is "out of the N" not "towards the N".
    wind_arrows = {'N' => '↓', 'NE' => '↙', 'E' => '←', 'SE' => '↖', 'S' => '↑', 'SW' => '↗', 'W' => '→', 'NW' => '↘'}

    data.each_with_index do |datum, index|
      str += wind_arrows[get_cardinal_direction_from_bearing datum[key]]
      data_limited.push datum
      data_points.push datum['windSpeed']
      break if index == hours - 1 # We only want (hours) 24hrs of data.
    end

    colored_str = get_colored_string(data_limited, 'windSpeed', str, get_wind_range_colors)

    return colored_str, data_points
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
    colored_str = get_colored_string(data, key, str, get_sun_range_colors)

    "8 day sun forecast |#{colored_str}|"
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

    colored_max_str = get_colored_string(data, 'temperatureMax', max_str, get_temp_range_colors)
    colored_min_str = get_colored_string(data, 'temperatureMin', min_str, get_temp_range_colors)

    "7day high/low temps #{get_temperature maxtemps.first.to_f.round(1)} |#{colored_max_str}| #{get_temperature maxtemps.last.to_f.round(1)} / #{get_temperature mintemps.first.to_f.round(1)} |#{colored_min_str}| #{get_temperature mintemps.last.to_f.round(1)} Range: #{get_temperature mintemps.min} - #{get_temperature maxtemps.max}"
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

  def conditions(forecast)
    temp_str, temps = do_the_temp_thing(forecast, ansi_chars, 8)
    wind_str, winds = do_the_wind_direction_thing(forecast, 8)
    rain_str, rains = do_the_rain_chance_thing(forecast, ansi_chars, 'precipProbability', 'probability', get_rain_range_colors)

    rs = compress_string(rain_str, 4)

    sun_chance = ((1 - forecast['daily']['data'][0]['cloudCover']) * 100).round
    "#{get_temperature temps.first.round(2)} |#{temp_str}| #{get_temperature temps.last.round(2)} " + "/ #{winds.first}mph |#{wind_str}| #{winds.last}mph / #{sun_chance}% chance of sun / 60m rain |#{rs}|"
  end

  def get_forecast_io_results(query = '45.5252,-122.6751')
    gps_coords, long_name = get_gps_coords query
    if @bot.is_a? Cinch::Test::MockBot
      forecast = get_mock_weather
    else
      url = config[:forecast_io_url] + config[:forecast_io_api_key] + '/' + gps_coords.to_s
      puts url
      forecast = HTTParty.get url
      forecast['long_name'] = long_name   # Hacking the location into the hash.
    end
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

  def get_percentage(number, differential, min)
    if differential == 0
      percentage = number
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
    #if probability == 0
    #  return Format(:blue, char_array[0])
    #elsif probability <= 0.10
    #  return Format(:purple, char_array[1])
    #elsif probability <= 0.25
    #  return Format(:teal, char_array[2])
    #elsif probability <= 0.50
    #  return Format(:yellow, char_array[3])
    #elsif probability <= 0.75
    #  return Format(:orange, char_array[4])
    #elsif probability <= 1.00
    #  return Format(:red, char_array[5])
    #end

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

  def get_mock_weather
    x = <<end
{"latitude":45.48563720000001,"longitude":-122.5946256,"timezone":"America/Los_Angeles","offset":-7,
"currently":{"time":1396935163,"summary":"Partly Cloudy","icon":"partly-cloudy-night","nearestStormDistance":31,"nearestStormBearing":7,"precipIntensity":0,"precipProbability":0,"temperature":56.89,"apparentTemperature":56.89,"dewPoint":48.43,"humidity":0.73,"windSpeed":2.42,"windBearing":20,"visibility":9.27,"cloudCover":0.39,"pressure":1019.76,"ozone":317.73},
"minutely":{"summary":"Partly cloudy for the hour.","icon":"partly-cloudy-night",
  "data":[{"time":1396935120,"precipIntensity":0,"precipProbability":0},{"time":1396935180,"precipIntensity":0.01,"precipProbability":0.1},{"time":1396935240,"precipIntensity":0.013,"precipProbability":0.2},{"time":1396935300,"precipIntensity":0.017,"precipProbability":0.3},{"time":1396935360,"precipIntensity":0.020,"precipProbability":0.4},{"time":1396935420,"precipIntensity":0.023,"precipProbability":0.5},{"time":1396935480,"precipIntensity":0.029,"precipProbability":0.6},{"time":1396935540,"precipIntensity":0.034,"precipProbability":0.7},{"time":1396935600,"precipIntensity":0.040,"precipProbability":0.8},{"time":1396935660,"precipIntensity":0.044,"precipProbability":0.9},{"time":1396935720,"precipIntensity":1,"precipProbability":1},{"time":1396935780,"precipIntensity":0,"precipProbability":0},{"time":1396935840,"precipIntensity":0,"precipProbability":0},{"time":1396935900,"precipIntensity":0,"precipProbability":0},{"time":1396935960,"precipIntensity":0,"precipProbability":0},{"time":1396936020,"precipIntensity":0,"precipProbability":0},{"time":1396936080,"precipIntensity":0,"precipProbability":0},{"time":1396936140,"precipIntensity":0,"precipProbability":0},{"time":1396936200,"precipIntensity":0,"precipProbability":0},{"time":1396936260,"precipIntensity":0,"precipProbability":0},{"time":1396936320,"precipIntensity":0,"precipProbability":0},{"time":1396936380,"precipIntensity":0,"precipProbability":0},{"time":1396936440,"precipIntensity":0,"precipProbability":0},{"time":1396936500,"precipIntensity":0,"precipProbability":0},{"time":1396936560,"precipIntensity":0,"precipProbability":0},{"time":1396936620,"precipIntensity":0,"precipProbability":0},{"time":1396936680,"precipIntensity":0,"precipProbability":0},{"time":1396936740,"precipIntensity":0,"precipProbability":0},{"time":1396936800,"precipIntensity":0,"precipProbability":0},{"time":1396936860,"precipIntensity":0,"precipProbability":0},{"time":1396936920,"precipIntensity":0,"precipProbability":0},{"time":1396936980,"precipIntensity":0,"precipProbability":0},{"time":1396937040,"precipIntensity":0,"precipProbability":0},{"time":1396937100,"precipIntensity":0,"precipProbability":0},{"time":1396937160,"precipIntensity":0,"precipProbability":0},{"time":1396937220,"precipIntensity":0,"precipProbability":0},{"time":1396937280,"precipIntensity":0,"precipProbability":0},{"time":1396937340,"precipIntensity":0,"precipProbability":0},{"time":1396937400,"precipIntensity":0,"precipProbability":0},{"time":1396937460,"precipIntensity":0,"precipProbability":0},{"time":1396937520,"precipIntensity":0,"precipProbability":0},{"time":1396937580,"precipIntensity":0,"precipProbability":0},{"time":1396937640,"precipIntensity":0,"precipProbability":0},{"time":1396937700,"precipIntensity":0,"precipProbability":0},{"time":1396937760,"precipIntensity":0,"precipProbability":0},{"time":1396937820,"precipIntensity":0,"precipProbability":0},{"time":1396937880,"precipIntensity":0,"precipProbability":0},{"time":1396937940,"precipIntensity":0,"precipProbability":0},{"time":1396938000,"precipIntensity":0,"precipProbability":0},{"time":1396938060,"precipIntensity":0,"precipProbability":0},{"time":1396938120,"precipIntensity":0,"precipProbability":0},{"time":1396938180,"precipIntensity":0,"precipProbability":0},{"time":1396938240,"precipIntensity":0,"precipProbability":0},{"time":1396938300,"precipIntensity":0,"precipProbability":0},{"time":1396938360,"precipIntensity":0,"precipProbability":0},{"time":1396938420,"precipIntensity":0,"precipProbability":0},{"time":1396938480,"precipIntensity":0,"precipProbability":0},{"time":1396938540,"precipIntensity":0,"precipProbability":0},{"time":1396938600,"precipIntensity":0,"precipProbability":0},{"time":1396938660,"precipIntensity":0,"precipProbability":0},{"time":1396938720,"precipIntensity":0,"precipProbability":0}]},
"hourly":{"summary":"Light rain tomorrow evening.","icon":"rain",
  "data":[{"time":1396933200,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":58.79,"apparentTemperature":58.79,"dewPoint":48.82,"humidity":0.69,"windSpeed":2.52,"windBearing":20,"visibility":9.47,"cloudCover":0.4,"pressure":1019.56,"ozone":317.54},{"time":1396936800,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":55.3,"apparentTemperature":55.3,"dewPoint":48.04,"humidity":0.77,"windSpeed":2.41,"windBearing":359,"visibility":9.1,"cloudCover":0.38,"pressure":1019.92,"ozone":317.88},{"time":1396940400,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":54.64,"apparentTemperature":54.64,"dewPoint":48.96,"humidity":0.81,"windSpeed":2.31,"windBearing":50,"visibility":8.98,"cloudCover":0.45,"pressure":1020.27,"ozone":318.04},{"time":1396944000,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":53.9,"apparentTemperature":53.9,"dewPoint":49.45,"humidity":0.85,"windSpeed":2.69,"windBearing":100,"visibility":8.87,"cloudCover":0.47,"pressure":1020.7,"ozone":318.15},{"time":1396947600,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":52.32,"apparentTemperature":52.32,"dewPoint":48.96,"humidity":0.88,"windSpeed":2.92,"windBearing":150,"visibility":8.81,"cloudCover":0.55,"pressure":1021.07,"ozone":318.62},{"time":1396951200,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":50.91,"apparentTemperature":50.91,"dewPoint":48.07,"humidity":0.9,"windSpeed":2.54,"windBearing":225,"visibility":8.77,"cloudCover":0.6,"pressure":1021.14,"ozone":319.66},{"time":1396954800,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":47.95,"apparentTemperature":47.95,"dewPoint":45.26,"humidity":0.9,"windSpeed":2.58,"windBearing":203,"visibility":8.71,"cloudCover":0.79,"pressure":1021.04,"ozone":321.05},{"time":1396958400,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":47.55,"apparentTemperature":47.55,"dewPoint":45.09,"humidity":0.91,"windSpeed":2.41,"windBearing":187,"visibility":8.68,"cloudCover":0.78,"pressure":1020.94,"ozone":322.55},{"time":1396962000,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":47.63,"apparentTemperature":47.63,"dewPoint":45.02,"humidity":0.91,"windSpeed":2.29,"windBearing":183,"visibility":8.75,"cloudCover":0.9,"pressure":1020.91,"ozone":324.21},{"time":1396965600,"summary":"Overcast","icon":"cloudy","precipIntensity":0,"precipProbability":0,"temperature":48.43,"apparentTemperature":48.43,"dewPoint":45.61,"humidity":0.9,"windSpeed":1.81,"windBearing":184,"visibility":8.79,"cloudCover":0.94,"pressure":1020.87,"ozone":325.97},{"time":1396969200,"summary":"Overcast","icon":"cloudy","precipIntensity":0,"precipProbability":0,"temperature":50.5,"apparentTemperature":50.5,"dewPoint":46.97,"humidity":0.88,"windSpeed":1.59,"windBearing":199,"visibility":8.94,"cloudCover":0.96,"pressure":1020.8,"ozone":327.45},{"time":1396972800,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":52.92,"apparentTemperature":52.92,"dewPoint":47.84,"humidity":0.83,"windSpeed":2.04,"windBearing":227,"visibility":9.25,"cloudCover":0.93,"pressure":1020.74,"ozone":328.41},{"time":1396976400,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":55.43,"apparentTemperature":55.43,"dewPoint":48.49,"humidity":0.77,"windSpeed":2.66,"windBearing":245,"visibility":9.5,"cloudCover":0.72,"pressure":1020.64,"ozone":329.08},{"time":1396980000,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":57.68,"apparentTemperature":57.68,"dewPoint":49.11,"humidity":0.73,"windSpeed":3.36,"windBearing":248,"visibility":9.66,"cloudCover":0.73,"pressure":1020.39,"ozone":329.81},{"time":1396983600,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":60.31,"apparentTemperature":60.31,"dewPoint":49.83,"humidity":0.68,"windSpeed":3.65,"windBearing":250,"visibility":9.9,"cloudCover":0.6,"pressure":1019.91,"ozone":330.66},{"time":1396987200,"summary":"Partly Cloudy","icon":"partly-cloudy-day","precipIntensity":0.0002,"precipProbability":0.01,"precipType":"rain","temperature":62.34,"apparentTemperature":62.34,"dewPoint":50,"humidity":0.64,"windSpeed":4.24,"windBearing":242,"visibility":10,"cloudCover":0.58,"pressure":1019.39,"ozone":331.57},{"time":1396990800,"summary":"Partly Cloudy","icon":"partly-cloudy-day","precipIntensity":0.0003,"precipProbability":0.01,"precipType":"rain","temperature":63.88,"apparentTemperature":63.88,"dewPoint":50.29,"humidity":0.61,"windSpeed":5.57,"windBearing":254,"visibility":10,"cloudCover":0.56,"pressure":1018.96,"ozone":332.59},{"time":1396994400,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0.0003,"precipProbability":0.01,"precipType":"rain","temperature":64.83,"apparentTemperature":64.83,"dewPoint":51.04,"humidity":0.61,"windSpeed":6.61,"windBearing":267,"visibility":10,"cloudCover":0.63,"pressure":1018.69,"ozone":333.77},{"time":1396998000,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":65,"apparentTemperature":65,"dewPoint":51.71,"humidity":0.62,"windSpeed":7.7,"windBearing":274,"visibility":10,"cloudCover":0.87,"pressure":1018.54,"ozone":335.08},{"time":1397001600,"summary":"Mostly Cloudy","icon":"partly-cloudy-day","precipIntensity":0.0012,"precipProbability":0.03,"precipType":"rain","temperature":64.57,"apparentTemperature":64.57,"dewPoint":52.29,"humidity":0.64,"windSpeed":8.61,"windBearing":282,"visibility":10,"cloudCover":0.92,"pressure":1018.57,"ozone":336.42},{"time":1397005200,"summary":"Overcast","icon":"cloudy","precipIntensity":0.0047,"precipProbability":0.16,"precipType":"rain","temperature":63.18,"apparentTemperature":63.18,"dewPoint":52.44,"humidity":0.68,"windSpeed":8.05,"windBearing":290,"visibility":10,"cloudCover":0.96,"pressure":1018.84,"ozone":338.08},{"time":1397008800,"summary":"Light Rain","icon":"rain","precipIntensity":0.0095,"precipProbability":0.3,"precipType":"rain","temperature":60.82,"apparentTemperature":60.82,"dewPoint":52.49,"humidity":0.74,"windSpeed":6.4,"windBearing":299,"visibility":10,"cloudCover":0.93,"pressure":1019.3,"ozone":339.77},{"time":1397012400,"summary":"Light Rain","icon":"rain","precipIntensity":0.0129,"precipProbability":0.42,"precipType":"rain","temperature":57.56,"apparentTemperature":57.56,"dewPoint":51.41,"humidity":0.8,"windSpeed":5.13,"windBearing":307,"visibility":10,"cloudCover":0.94,"pressure":1019.86,"ozone":340.62},{"time":1397016000,"summary":"Light Rain","icon":"rain","precipIntensity":0.0126,"precipProbability":0.47,"precipType":"rain","temperature":55.85,"apparentTemperature":55.85,"dewPoint":51,"humidity":0.84,"windSpeed":4.53,"windBearing":310,"visibility":10,"cloudCover":0.95,"pressure":1020.55,"ozone":339.81},{"time":1397019600,"summary":"Light Rain","icon":"rain","precipIntensity":0.0105,"precipProbability":0.5,"precipType":"rain","temperature":54.43,"apparentTemperature":54.43,"dewPoint":51.18,"humidity":0.89,"windSpeed":4.27,"windBearing":311,"visibility":10,"cloudCover":0.97,"pressure":1021.3,"ozone":338.16},{"time":1397023200,"summary":"Drizzle","icon":"rain","precipIntensity":0.0085,"precipProbability":0.44,"precipType":"rain","temperature":53.34,"apparentTemperature":53.34,"dewPoint":50.72,"humidity":0.91,"windSpeed":4.21,"windBearing":312,"visibility":10,"cloudCover":0.95,"pressure":1021.91,"ozone":337.25},{"time":1397026800,"summary":"Drizzle","icon":"rain","precipIntensity":0.007,"precipProbability":0.36,"precipType":"rain","temperature":51.86,"apparentTemperature":51.86,"dewPoint":49.47,"humidity":0.92,"windSpeed":4.45,"windBearing":321,"visibility":10,"cloudCover":0.86,"pressure":1022.29,"ozone":337.02},{"time":1397030400,"summary":"Drizzle","icon":"rain","precipIntensity":0.0057,"precipProbability":0.28,"precipType":"rain","temperature":50.44,"apparentTemperature":50.44,"dewPoint":47.94,"humidity":0.91,"windSpeed":4.2,"windBearing":325,"visibility":10,"cloudCover":0.74,"pressure":1022.55,"ozone":337.54},{"time":1397034000,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0.0045,"precipProbability":0.21,"precipType":"rain","temperature":49.15,"apparentTemperature":47.85,"dewPoint":46.61,"humidity":0.91,"windSpeed":4.05,"windBearing":329,"visibility":10,"cloudCover":0.66,"pressure":1022.81,"ozone":340.58},{"time":1397037600,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0.0036,"precipProbability":0.17,"precipType":"rain","temperature":46.94,"apparentTemperature":45.69,"dewPoint":44.76,"humidity":0.92,"windSpeed":3.57,"windBearing":333,"visibility":10,"cloudCover":0.64,"pressure":1023.09,"ozone":348.36},{"time":1397041200,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0.0029,"precipProbability":0.15,"precipType":"rain","temperature":45.34,"apparentTemperature":45.34,"dewPoint":43.51,"humidity":0.93,"windSpeed":2.91,"windBearing":339,"visibility":10,"cloudCover":0.66,"pressure":1023.36,"ozone":358.66},{"time":1397044800,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0.0022,"precipProbability":0.13,"precipType":"rain","temperature":44.07,"apparentTemperature":44.07,"dewPoint":42.37,"humidity":0.94,"windSpeed":2.45,"windBearing":345,"visibility":10,"cloudCover":0.63,"pressure":1023.66,"ozone":366.59},{"time":1397048400,"summary":"Partly Cloudy","icon":"partly-cloudy-night","precipIntensity":0.0015,"precipProbability":0.09,"precipType":"rain","temperature":43.69,"apparentTemperature":43.69,"dewPoint":41.93,"humidity":0.93,"windSpeed":2.3,"windBearing":349,"visibility":10,"cloudCover":0.46,"pressure":1024.03,"ozone":370.23},{"time":1397052000,"summary":"Clear","icon":"clear-day","precipIntensity":0.0007,"precipProbability":0.04,"precipType":"rain","temperature":43.87,"apparentTemperature":43.87,"dewPoint":41.82,"humidity":0.92,"windSpeed":2.39,"windBearing":350,"visibility":10,"cloudCover":0.24,"pressure":1024.45,"ozone":371.5},{"time":1397055600,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":44.96,"apparentTemperature":44.96,"dewPoint":41.9,"humidity":0.89,"windSpeed":2.73,"windBearing":349,"visibility":10,"cloudCover":0.08,"pressure":1024.81,"ozone":371.28},{"time":1397059200,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":47.38,"apparentTemperature":46.36,"dewPoint":41.95,"humidity":0.81,"windSpeed":3.37,"windBearing":349,"visibility":10,"cloudCover":0.04,"pressure":1025.11,"ozone":369.28},{"time":1397062800,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":50.36,"apparentTemperature":50.36,"dewPoint":41.45,"humidity":0.71,"windSpeed":4.31,"windBearing":349,"visibility":10,"cloudCover":0.06,"pressure":1025.31,"ozone":365.79},{"time":1397066400,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":52.91,"apparentTemperature":52.91,"dewPoint":40.47,"humidity":0.63,"windSpeed":5.06,"windBearing":347,"visibility":10,"cloudCover":0.1,"pressure":1025.32,"ozone":362.59},{"time":1397070000,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":55.1,"apparentTemperature":55.1,"dewPoint":39.72,"humidity":0.56,"windSpeed":5.62,"windBearing":342,"visibility":10,"cloudCover":0.13,"pressure":1025.01,"ozone":360.38},{"time":1397073600,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":57.12,"apparentTemperature":57.12,"dewPoint":39.03,"humidity":0.51,"windSpeed":6.05,"windBearing":337,"visibility":10,"cloudCover":0.17,"pressure":1024.48,"ozone":358.47},{"time":1397077200,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":58.68,"apparentTemperature":58.68,"dewPoint":38.29,"humidity":0.47,"windSpeed":6.5,"windBearing":334,"visibility":10,"cloudCover":0.19,"pressure":1023.93,"ozone":356.53},{"time":1397080800,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":59.75,"apparentTemperature":59.75,"dewPoint":37.41,"humidity":0.43,"windSpeed":7.25,"windBearing":335,"visibility":10,"cloudCover":0.13,"pressure":1023.39,"ozone":354.4},{"time":1397084400,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":60.23,"apparentTemperature":60.23,"dewPoint":36.76,"humidity":0.42,"windSpeed":7.97,"windBearing":337,"visibility":10,"cloudCover":0.04,"pressure":1022.88,"ozone":352.25},{"time":1397088000,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":59.72,"apparentTemperature":59.72,"dewPoint":36.84,"humidity":0.42,"windSpeed":8.15,"windBearing":339,"visibility":10,"cloudCover":0.03,"pressure":1022.55,"ozone":350.28},{"time":1397091600,"summary":"Clear","icon":"clear-day","precipIntensity":0,"precipProbability":0,"temperature":57.85,"apparentTemperature":57.85,"dewPoint":37.99,"humidity":0.47,"windSpeed":7.44,"windBearing":340,"visibility":10,"cloudCover":0.2,"pressure":1022.55,"ozone":348.56},{"time":1397095200,"summary":"Partly Cloudy","icon":"partly-cloudy-day","precipIntensity":0,"precipProbability":0,"temperature":54.72,"apparentTemperature":54.72,"dewPoint":38.89,"humidity":0.55,"windSpeed":6.22,"windBearing":340,"visibility":10,"cloudCover":0.46,"pressure":1022.78,"ozone":347.03},{"time":1397098800,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":51.92,"apparentTemperature":51.92,"dewPoint":39.32,"humidity":0.62,"windSpeed":5.21,"windBearing":339,"visibility":10,"cloudCover":0.67,"pressure":1023.08,"ozone":345.72},{"time":1397102400,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":49.81,"apparentTemperature":48.08,"dewPoint":39.42,"humidity":0.67,"windSpeed":4.86,"windBearing":339,"visibility":10,"cloudCover":0.8,"pressure":1023.46,"ozone":344.72},{"time":1397106000,"summary":"Mostly Cloudy","icon":"partly-cloudy-night","precipIntensity":0,"precipProbability":0,"temperature":47.89,"apparentTemperature":45.95,"dewPoint":39.22,"humidity":0.72,"windSpeed":4.69,"windBearing":337,"visibility":10,"cloudCover":0.89,"pressure":1023.9,"ozone":343.95}]},
"daily":{"summary":"Light rain tomorrow through Monday, with temperatures peaking at 73°F on Sunday.","icon":"rain","data":[{"time":1396854000,"summary":"Partly cloudy throughout the day.","icon":"partly-cloudy-day","sunriseTime":1396878016,"sunsetTime":1396925208,"moonPhase":0.28,"precipIntensity":0,"precipIntensityMax":0.0001,"precipIntensityMaxTime":1396850400,"precipProbability":0,"temperatureMin":45.95,"temperatureMinTime":1396868400,"temperatureMax":72.31,"temperatureMaxTime":1396915200,"apparentTemperatureMin":45.95,"apparentTemperatureMinTime":1396868400,"apparentTemperatureMax":72.31,"apparentTemperatureMaxTime":1396915200,"dewPoint":47.97,"humidity":0.73,"windSpeed":0.77,"windBearing":222,"visibility":9.93,"cloudCover":0.47,"pressure":1022.6,"ozone":313.53},{"time":1396940400,"summary":"Light rain in the evening.","icon":"rain","sunriseTime":1396964305,"sunsetTime":1397011686,"moonPhase":0.31,"precipIntensity":0.0025,"precipIntensityMax":0.0129,"precipIntensityMaxTime":1397012400,"precipProbability":0.5,"precipType":"rain","temperatureMin":47.55,"temperatureMinTime":1396958400,"temperatureMax":65,"temperatureMaxTime":1396998000,"apparentTemperatureMin":47.55,"apparentTemperatureMinTime":1396958400,"apparentTemperatureMax":65,"apparentTemperatureMaxTime":1396998000,"dewPoint":49.3,"humidity":0.79,"windSpeed":3.35,"windBearing":267,"visibility":9.48,"cloudCover":0.78,"pressure":1020.22,"ozone":329.87},{"time":1397026800,"summary":"Mostly cloudy in the evening.","icon":"partly-cloudy-day","sunriseTime":1397050594,"sunsetTime":1397098163,"moonPhase":0.34,"precipIntensity":0.0012,"precipIntensityMax":0.007,"precipIntensityMaxTime":1397026800,"precipProbability":0.36,"precipType":"rain","temperatureMin":43.69,"temperatureMinTime":1397048400,"temperatureMax":60.23,"temperatureMaxTime":1397084400,"apparentTemperatureMin":43.69,"apparentTemperatureMinTime":1397048400,"apparentTemperatureMax":60.23,"apparentTemperatureMaxTime":1397084400,"dewPoint":41.07,"humidity":0.71,"windSpeed":4.8,"windBearing":338,"visibility":10,"cloudCover":0.41,"pressure":1023.71,"ozone":354.37},{"time":1397113200,"summary":"Partly cloudy starting in the afternoon, continuing until evening.","icon":"partly-cloudy-day","sunriseTime":1397136884,"sunsetTime":1397184640,"moonPhase":0.38,"precipIntensity":0,"precipIntensityMax":0,"precipProbability":0,"temperatureMin":39.14,"temperatureMinTime":1397131200,"temperatureMax":61.12,"temperatureMaxTime":1397170800,"apparentTemperatureMin":39.14,"apparentTemperatureMinTime":1397131200,"apparentTemperatureMax":61.12,"apparentTemperatureMaxTime":1397170800,"dewPoint":37.69,"humidity":0.66,"windSpeed":4.19,"windBearing":333,"visibility":10,"cloudCover":0.2,"pressure":1022.04,"ozone":336.11},{"time":1397199600,"summary":"Partly cloudy until afternoon.","icon":"partly-cloudy-day","sunriseTime":1397223175,"sunsetTime":1397271117,"moonPhase":0.41,"precipIntensity":0,"precipIntensityMax":0,"precipProbability":0,"temperatureMin":40.24,"temperatureMinTime":1397217600,"temperatureMax":68.52,"temperatureMaxTime":1397257200,"apparentTemperatureMin":40.24,"apparentTemperatureMinTime":1397217600,"apparentTemperatureMax":68.52,"apparentTemperatureMaxTime":1397257200,"dewPoint":43.8,"humidity":0.73,"windSpeed":3.99,"windBearing":333,"visibility":10,"cloudCover":0.16,"pressure":1018.46,"ozone":335.8},{"time":1397286000,"summary":"Clear throughout the day.","icon":"clear-day","sunriseTime":1397309467,"sunsetTime":1397357595,"moonPhase":0.45,"precipIntensity":0,"precipIntensityMax":0,"precipProbability":0,"temperatureMin":36.58,"temperatureMinTime":1397304000,"temperatureMax":70.96,"temperatureMaxTime":1397343600,"apparentTemperatureMin":36.58,"apparentTemperatureMinTime":1397304000,"apparentTemperatureMax":70.96,"apparentTemperatureMaxTime":1397343600,"dewPoint":44.05,"humidity":0.73,"windSpeed":2.82,"windBearing":350,"cloudCover":0.03,"pressure":1016.94,"ozone":346.08},{"time":1397372400,"summary":"Mostly cloudy starting in the afternoon.","icon":"partly-cloudy-day","sunriseTime":1397395759,"sunsetTime":1397444072,"moonPhase":0.48,"precipIntensity":0.0004,"precipIntensityMax":0.0012,"precipIntensityMaxTime":1397455200,"precipProbability":0.11,"precipType":"rain","temperatureMin":45.16,"temperatureMinTime":1397390400,"temperatureMax":73.42,"temperatureMaxTime":1397430000,"apparentTemperatureMin":42.58,"apparentTemperatureMinTime":1397390400,"apparentTemperatureMax":73.42,"apparentTemperatureMaxTime":1397430000,"dewPoint":45.13,"humidity":0.63,"windSpeed":5.24,"windBearing":78,"cloudCover":0.25,"pressure":1016.28,"ozone":343.49},{"time":1397458800,"summary":"Light rain starting in the afternoon.","icon":"rain","sunriseTime":1397482051,"sunsetTime":1397530550,"moonPhase":0.51,"precipIntensity":0.004,"precipIntensityMax":0.0091,"precipIntensityMaxTime":1397530800,"precipProbability":0.59,"precipType":"rain","temperatureMin":46.56,"temperatureMinTime":1397480400,"temperatureMax":59.88,"temperatureMaxTime":1397509200,"apparentTemperatureMin":44.67,"apparentTemperatureMinTime":1397476800,"apparentTemperatureMax":59.88,"apparentTemperatureMaxTime":1397509200,"dewPoint":46.65,"humidity":0.8,"windSpeed":6.03,"windBearing":209,"cloudCover":0.65,"pressure":1014.67,"ozone":386.21}]},
"flags":{"sources":["nwspa","isd","nearest-precip","gfs","fnmoc","sref","rtma","rap","nam","cmc","lamp","madis","darksky"],"isd-stations":["726980-24229","727918-94298","727918-99999","999999-24229","999999-24274"],"lamp-stations":["KHIO","KPDX","KTTD","KUAO","KVUO"],"madis-stations":["C7021","D3762","D4360","E1617","E3POR"],"darksky-stations":["KRTX"],"units":"us"}}
end
    JSON.parse x
  end
end
