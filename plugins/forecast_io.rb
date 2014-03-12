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

  set :help, <<-EOF
This is the weather prediction module.  Location is optional, and defaults to Portland, OR.
Once you specify a location, it will persist as long as you own your nick.
!forecast   [location] Forecast IO forecast for Portland.
!asciirain  [location] Incoming rain data for the next hour.
!ansirain   [location] Fancy incoming rain data for the next hour.
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

  EOF

  # Twillio response block
  get '/forecast' do
    bot = self.bot
    request = params[:Body]

    case request
      when /^forecast/i
        text = bot.plugins[4].get_weather_forecast(request.sub /^forecast\s*/i, '')
      when /^rain/i
        text = bot.plugins[4].sms_rain_forecast request.sub(/^rain\s*/i, '')
      when /^temp/i
        text = bot.plugins[4].do_the_temp_thing(request.sub(/^temp\s*/i, ''), @@ansi_chars)
      when /^cond/i
        text = bot.plugins[4].conditions(request.sub(/^temp\s*/i, ''), @@ansi_chars)
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

x = <<-end
{
latitude: 45.5252,
longitude: -122.6751,
timezone: "America/Los_Angeles",
offset: -8,
currently: {
time: 1391332905,
summary: "Clear",
icon: "clear-night",
nearestStormDistance: 10,
nearestStormBearing: 159,
precipIntensity: 0,
precipProbability: 0,
temperature: 33.18,
apparentTemperature: 30.36,
dewPoint: 29.98,
humidity: 0.88,
windSpeed: 3.22,
windBearing: 56,
visibility: 8.72,
buttCover: 0,
pressure: 1017.18,
ozone: 359.13
},
minutely: {
summary: "Clear for the hour.",
icon: "clear-night",
data: [
{
time: 1391332860,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391332920,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391332980,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333040,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333100,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333160,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333220,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333280,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333340,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333400,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333460,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333520,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333580,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333640,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333700,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333760,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333820,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333880,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391333940,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334000,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334060,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334120,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334180,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334240,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334300,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334360,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334420,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334480,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334540,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334600,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334660,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334720,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334780,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334840,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334900,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391334960,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335020,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335080,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335140,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335200,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335260,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335320,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335380,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335440,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335500,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335560,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335620,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335680,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335740,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335800,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335860,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335920,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391335980,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336040,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336100,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336160,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336220,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336280,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336340,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336400,
precipIntensity: 0,
precipProbability: 0
},
{
time: 1391336460,
precipIntensity: 0,
precipProbability: 0
}
]
},
hourly: {
summary: "Mostly butty throughout the day.",
icon: "partly-butty-day",
data: [
{
time: 1391331600,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 33.41,
apparentTemperature: 33.41,
dewPoint: 30.3,
humidity: 0.88,
windSpeed: 2.8,
windBearing: 56,
visibility: 8.66,
buttCover: 0.01,
pressure: 1017.34,
ozone: 357.92
},
{
time: 1391335200,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 32.77,
apparentTemperature: 29.03,
dewPoint: 29.42,
humidity: 0.87,
windSpeed: 3.95,
windBearing: 55,
visibility: 8.8,
buttCover: 0,
pressure: 1016.9,
ozone: 361.26
},
{
time: 1391338800,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 32.46,
apparentTemperature: 28.38,
dewPoint: 28.86,
humidity: 0.86,
windSpeed: 4.21,
windBearing: 51,
visibility: 8.88,
buttCover: 0.04,
pressure: 1016.37,
ozone: 365
},
{
time: 1391342400,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 32.24,
apparentTemperature: 28.04,
dewPoint: 28.29,
humidity: 0.85,
windSpeed: 4.29,
windBearing: 50,
visibility: 7.77,
buttCover: 0.08,
pressure: 1016.02,
ozone: 367.89
},
{
time: 1391346000,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 31.95,
apparentTemperature: 27.79,
dewPoint: 27.78,
humidity: 0.84,
windSpeed: 4.22,
windBearing: 51,
visibility: 7.84,
buttCover: 0.16,
pressure: 1016,
ozone: 369.47
},
{
time: 1391349600,
summary: "Partly Butty",
icon: "partly-butty-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 31.86,
apparentTemperature: 27.98,
dewPoint: 27.58,
humidity: 0.84,
windSpeed: 3.94,
windBearing: 53,
visibility: 9.03,
buttCover: 0.34,
pressure: 1016.14,
ozone: 370.21
},
{
time: 1391353200,
summary: "Partly Butty",
icon: "partly-butty-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 32.1,
apparentTemperature: 28.16,
dewPoint: 27.4,
humidity: 0.83,
windSpeed: 4.04,
windBearing: 56,
visibility: 9.04,
buttCover: 0.34,
pressure: 1016.28,
ozone: 370.3
},
{
time: 1391356800,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 33.61,
apparentTemperature: 30.11,
dewPoint: 28.16,
humidity: 0.8,
windSpeed: 3.84,
windBearing: 63,
visibility: 9.1,
buttCover: 0.42,
pressure: 1016.41,
ozone: 368.81
},
{
time: 1391360400,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 36.04,
apparentTemperature: 33.11,
dewPoint: 29.31,
humidity: 0.76,
windSpeed: 3.66,
windBearing: 72,
visibility: 9.19,
buttCover: 0.46,
pressure: 1016.54,
ozone: 366.68
},
{
time: 1391364000,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 38.69,
apparentTemperature: 36.49,
dewPoint: 30.65,
humidity: 0.73,
windSpeed: 3.34,
windBearing: 80,
visibility: 9.41,
buttCover: 0.48,
pressure: 1016.47,
ozone: 366.87
},
{
time: 1391367600,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 41.05,
apparentTemperature: 41.05,
dewPoint: 31.99,
humidity: 0.7,
windSpeed: 2.53,
windBearing: 82,
visibility: 9.67,
buttCover: 0.42,
pressure: 1016.04,
ozone: 371.75
},
{
time: 1391371200,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 43.06,
apparentTemperature: 43.06,
dewPoint: 32.44,
humidity: 0.66,
windSpeed: 1.57,
windBearing: 66,
visibility: 9.78,
buttCover: 0.49,
pressure: 1015.43,
ozone: 378.96
},
{
time: 1391374800,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 44.23,
apparentTemperature: 44.23,
dewPoint: 32.78,
humidity: 0.64,
windSpeed: 1.25,
windBearing: 11,
visibility: 9.7,
buttCover: 0.49,
pressure: 1014.93,
ozone: 384.39
},
{
time: 1391378400,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0012,
precipProbability: 0.04,
precipType: "rain",
temperature: 45.01,
apparentTemperature: 45.01,
dewPoint: 33.24,
humidity: 0.63,
windSpeed: 1.32,
windBearing: 342,
visibility: 9.65,
buttCover: 0.54,
pressure: 1014.59,
ozone: 386.48
},
{
time: 1391382000,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0009,
precipProbability: 0.04,
precipType: "rain",
temperature: 45.57,
apparentTemperature: 45.57,
dewPoint: 33.68,
humidity: 0.63,
windSpeed: 0.79,
windBearing: 322,
visibility: 9.64,
buttCover: 0.61,
pressure: 1014.34,
ozone: 386.81
},
{
time: 1391385600,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0,
precipProbability: 0,
temperature: 45.46,
apparentTemperature: 45.46,
dewPoint: 34.06,
humidity: 0.64,
windSpeed: 1.01,
windBearing: 299,
visibility: 9.62,
buttCover: 0.71,
pressure: 1014.27,
ozone: 385.99
},
{
time: 1391389200,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0013,
precipProbability: 0.03,
precipType: "rain",
temperature: 44.24,
apparentTemperature: 44.24,
dewPoint: 34.48,
humidity: 0.68,
windSpeed: 1.67,
windBearing: 309,
visibility: 9.32,
buttCover: 0.72,
pressure: 1014.4,
ozone: 382.97
},
{
time: 1391392800,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0023,
precipProbability: 0.07,
precipType: "rain",
temperature: 42.43,
apparentTemperature: 42.43,
dewPoint: 34.42,
humidity: 0.73,
windSpeed: 2.09,
windBearing: 314,
visibility: 9.07,
buttCover: 0.86,
pressure: 1014.69,
ozone: 378.81
},
{
time: 1391396400,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0025,
precipProbability: 0.12,
precipType: "rain",
temperature: 40.87,
apparentTemperature: 40.87,
dewPoint: 34.53,
humidity: 0.78,
windSpeed: 2.5,
windBearing: 329,
visibility: 9.44,
buttCover: 0.9,
pressure: 1015.03,
ozone: 377.35
},
{
time: 1391400000,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0027,
precipProbability: 0.16,
precipType: "rain",
temperature: 39.55,
apparentTemperature: 37.51,
dewPoint: 33.87,
humidity: 0.8,
windSpeed: 3.3,
windBearing: 338,
visibility: 9.69,
buttCover: 0.87,
pressure: 1015.39,
ozone: 381.36
},
{
time: 1391403600,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0028,
precipProbability: 0.18,
precipType: "rain",
temperature: 38.37,
apparentTemperature: 35.66,
dewPoint: 33.4,
humidity: 0.82,
windSpeed: 3.77,
windBearing: 340,
visibility: 9.84,
buttCover: 0.81,
pressure: 1015.74,
ozone: 388.08
},
{
time: 1391407200,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0027,
precipProbability: 0.19,
precipType: "rain",
temperature: 37.3,
apparentTemperature: 34.48,
dewPoint: 32.36,
humidity: 0.82,
windSpeed: 3.72,
windBearing: 339,
visibility: 9.92,
buttCover: 0.76,
pressure: 1016.05,
ozone: 393.06
},
{
time: 1391410800,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0023,
precipProbability: 0.16,
precipType: "rain",
temperature: 35.82,
apparentTemperature: 32.88,
dewPoint: 31.27,
humidity: 0.83,
windSpeed: 3.63,
windBearing: 337,
visibility: 10,
buttCover: 0.72,
pressure: 1016.36,
ozone: 393.92
},
{
time: 1391414400,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0016,
precipProbability: 0.09,
precipType: "rain",
temperature: 34.89,
apparentTemperature: 32.25,
dewPoint: 30.98,
humidity: 0.85,
windSpeed: 3.27,
windBearing: 329,
visibility: 10,
buttCover: 0.7,
pressure: 1016.65,
ozone: 393.05
},
{
time: 1391418000,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.001,
precipProbability: 0.04,
precipType: "rain",
temperature: 34.12,
apparentTemperature: 34.12,
dewPoint: 31.14,
humidity: 0.89,
windSpeed: 2.58,
windBearing: 314,
visibility: 10,
buttCover: 0.71,
pressure: 1016.89,
ozone: 393.17
},
{
time: 1391421600,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0006,
precipProbability: 0.01,
precipType: "rain",
temperature: 33.62,
apparentTemperature: 33.62,
dewPoint: 30.79,
humidity: 0.89,
windSpeed: 1.82,
windBearing: 301,
visibility: 10,
buttCover: 0.72,
pressure: 1017.07,
ozone: 395.55
},
{
time: 1391425200,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0,
precipProbability: 0,
temperature: 33.42,
apparentTemperature: 33.42,
dewPoint: 30.63,
humidity: 0.89,
windSpeed: 0.98,
windBearing: 270,
visibility: 10,
buttCover: 0.81,
pressure: 1017.2,
ozone: 398.93
},
{
time: 1391428800,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0007,
precipProbability: 0.03,
precipType: "rain",
temperature: 33.45,
apparentTemperature: 33.45,
dewPoint: 30.71,
humidity: 0.9,
windSpeed: 0.87,
windBearing: 219,
visibility: 10,
buttCover: 0.89,
pressure: 1017.39,
ozone: 402.21
},
{
time: 1391432400,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0023,
precipProbability: 0.13,
precipType: "rain",
temperature: 33.3,
apparentTemperature: 33.3,
dewPoint: 30.86,
humidity: 0.91,
windSpeed: 1.2,
windBearing: 208,
visibility: 10,
buttCover: 0.92,
pressure: 1017.64,
ozone: 405.15
},
{
time: 1391436000,
summary: "Mostly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0045,
precipProbability: 0.25,
precipType: "rain",
temperature: 33.08,
apparentTemperature: 33.08,
dewPoint: 30.97,
humidity: 0.92,
windSpeed: 1.48,
windBearing: 210,
visibility: 10,
buttCover: 0.92,
pressure: 1017.93,
ozone: 407.98
},
{
time: 1391439600,
summary: "Drizzle",
icon: "rain",
precipIntensity: 0.0057,
precipProbability: 0.3,
precipType: "rain",
temperature: 33.41,
apparentTemperature: 33.41,
dewPoint: 31.13,
humidity: 0.91,
windSpeed: 1.52,
windBearing: 215,
visibility: 10,
buttCover: 0.9,
pressure: 1018.27,
ozone: 410.41
},
{
time: 1391443200,
summary: "Drizzle",
icon: "rain",
precipIntensity: 0.005,
precipProbability: 0.28,
precipType: "rain",
temperature: 34.41,
apparentTemperature: 34.41,
dewPoint: 31.04,
humidity: 0.87,
windSpeed: 1.29,
windBearing: 223,
visibility: 10,
buttCover: 0.89,
pressure: 1018.74,
ozone: 412.3
},
{
time: 1391446800,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0033,
precipProbability: 0.21,
precipType: "rain",
temperature: 35.81,
apparentTemperature: 35.81,
dewPoint: 30.74,
humidity: 0.82,
windSpeed: 1.08,
windBearing: 237,
visibility: 10,
buttCover: 0.87,
pressure: 1019.24,
ozone: 413.79
},
{
time: 1391450400,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0019,
precipProbability: 0.14,
precipType: "rain",
temperature: 37.33,
apparentTemperature: 37.33,
dewPoint: 30.5,
humidity: 0.76,
windSpeed: 1.14,
windBearing: 256,
visibility: 10,
buttCover: 0.8,
pressure: 1019.56,
ozone: 414.94
},
{
time: 1391454000,
summary: "Mostly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0013,
precipProbability: 0.09,
precipType: "rain",
temperature: 38.75,
apparentTemperature: 38.75,
dewPoint: 30.25,
humidity: 0.71,
windSpeed: 1.66,
windBearing: 276,
visibility: 10,
buttCover: 0.66,
pressure: 1019.53,
ozone: 416.14
},
{
time: 1391457600,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.001,
precipProbability: 0.05,
precipType: "rain",
temperature: 39.96,
apparentTemperature: 39.96,
dewPoint: 29.76,
humidity: 0.67,
windSpeed: 2.38,
windBearing: 288,
visibility: 10,
buttCover: 0.47,
pressure: 1019.28,
ozone: 417.01
},
{
time: 1391461200,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0008,
precipProbability: 0.03,
precipType: "rain",
temperature: 40.83,
apparentTemperature: 40.83,
dewPoint: 29.36,
humidity: 0.63,
windSpeed: 2.9,
windBearing: 294,
visibility: 10,
buttCover: 0.35,
pressure: 1019.12,
ozone: 416.56
},
{
time: 1391464800,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0007,
precipProbability: 0.02,
precipType: "rain",
temperature: 41.29,
apparentTemperature: 39.56,
dewPoint: 29.23,
humidity: 0.62,
windSpeed: 3.24,
windBearing: 297,
visibility: 10,
buttCover: 0.36,
pressure: 1019.07,
ozone: 413.99
},
{
time: 1391468400,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0008,
precipProbability: 0.03,
precipType: "rain",
temperature: 41.29,
apparentTemperature: 39.31,
dewPoint: 29.2,
humidity: 0.62,
windSpeed: 3.47,
windBearing: 302,
visibility: 10,
buttCover: 0.45,
pressure: 1019.11,
ozone: 410.11
},
{
time: 1391472000,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0008,
precipProbability: 0.03,
precipType: "rain",
temperature: 40.58,
apparentTemperature: 38.67,
dewPoint: 29.03,
humidity: 0.63,
windSpeed: 3.31,
windBearing: 309,
visibility: 10,
buttCover: 0.49,
pressure: 1019.35,
ozone: 406.22
},
{
time: 1391475600,
summary: "Partly Butty",
icon: "partly-butty-day",
precipIntensity: 0.0007,
precipProbability: 0.03,
precipType: "rain",
temperature: 38.63,
apparentTemperature: 38.63,
dewPoint: 28.45,
humidity: 0.67,
windSpeed: 2.74,
windBearing: 328,
visibility: 10,
buttCover: 0.45,
pressure: 1019.91,
ozone: 402.44
},
{
time: 1391479200,
summary: "Partly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0006,
precipProbability: 0.03,
precipType: "rain",
temperature: 36.3,
apparentTemperature: 36.3,
dewPoint: 27.9,
humidity: 0.71,
windSpeed: 2.47,
windBearing: 5,
visibility: 10,
buttCover: 0.37,
pressure: 1020.65,
ozone: 398.67
},
{
time: 1391482800,
summary: "Partly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0005,
precipProbability: 0.02,
precipType: "rain",
temperature: 34.52,
apparentTemperature: 34.52,
dewPoint: 27.49,
humidity: 0.75,
windSpeed: 2.86,
windBearing: 32,
visibility: 10,
buttCover: 0.3,
pressure: 1021.32,
ozone: 395.88
},
{
time: 1391486400,
summary: "Partly Butty",
icon: "partly-butty-night",
precipIntensity: 0.0005,
precipProbability: 0.02,
precipType: "rain",
temperature: 33.22,
apparentTemperature: 30.37,
dewPoint: 26.97,
humidity: 0.78,
windSpeed: 3.24,
windBearing: 51,
visibility: 10,
buttCover: 0.25,
pressure: 1021.83,
ozone: 394.78
},
{
time: 1391490000,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0.0004,
precipProbability: 0.02,
precipType: "rain",
temperature: 32.26,
apparentTemperature: 28.79,
dewPoint: 26.49,
humidity: 0.79,
windSpeed: 3.64,
windBearing: 67,
visibility: 10,
buttCover: 0.23,
pressure: 1022.27,
ozone: 394.66
},
{
time: 1391493600,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0.0003,
precipProbability: 0.01,
precipType: "snow",
temperature: 31.47,
apparentTemperature: 27.21,
dewPoint: 25.9,
humidity: 0.8,
windSpeed: 4.23,
windBearing: 80,
visibility: 10,
buttCover: 0.21,
pressure: 1022.68,
ozone: 394.4
},
{
time: 1391497200,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0.0003,
precipProbability: 0.01,
precipType: "snow",
temperature: 30.73,
apparentTemperature: 25.64,
dewPoint: 25.07,
humidity: 0.79,
windSpeed: 4.94,
windBearing: 87,
visibility: 10,
buttCover: 0.2,
pressure: 1023.08,
ozone: 393.47
},
{
time: 1391500800,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0.0003,
precipProbability: 0.01,
precipType: "snow",
temperature: 30.09,
apparentTemperature: 24.33,
dewPoint: 24.1,
humidity: 0.78,
windSpeed: 5.54,
windBearing: 92,
visibility: 10,
buttCover: 0.2,
pressure: 1023.46,
ozone: 392.4
},
{
time: 1391504400,
summary: "Clear",
icon: "clear-night",
precipIntensity: 0.0003,
precipProbability: 0.01,
precipType: "snow",
temperature: 29.45,
apparentTemperature: 23.21,
dewPoint: 23.14,
humidity: 0.77,
windSpeed: 5.98,
windBearing: 94,
visibility: 10,
buttCover: 0.21,
pressure: 1023.77,
ozone: 391.55
}
]
},
daily: {
summary: "Mixed precipitation later this week; temperatures falling to 30° on Wednesday.",
icon: "rain",
data: [
{
time: 1391328000,
summary: "Mostly butty throughout the day.",
icon: "partly-butty-day",
sunriseTime: 1391355108,
sunsetTime: 1391390377,
moonPhase: 0.11,
precipIntensity: 0.0008,
precipIntensityMax: 0.0028,
precipIntensityMaxTime: 1391403600,
precipProbability: 0.19,
precipType: "rain",
temperatureMin: 31.86,
temperatureMinTime: 1391349600,
temperatureMax: 45.57,
temperatureMaxTime: 1391382000,
apparentTemperatureMin: 27.79,
apparentTemperatureMinTime: 1391346000,
apparentTemperatureMax: 45.57,
apparentTemperatureMaxTime: 1391382000,
dewPoint: 31.3,
humidity: 0.77,
windSpeed: 2.1,
windBearing: 30,
visibility: 9.15,
buttCover: 0.47,
pressure: 1015.8,
ozone: 375.42
},
{
time: 1391414400,
summary: "Mostly butty until evening.",
icon: "partly-butty-day",
sunriseTime: 1391441434,
sunsetTime: 1391476865,
moonPhase: 0.14,
precipIntensity: 0.0015,
precipIntensityMax: 0.0057,
precipIntensityMaxTime: 1391439600,
precipProbability: 0.3,
precipType: "rain",
temperatureMin: 30.73,
temperatureMinTime: 1391497200,
temperatureMax: 41.29,
temperatureMaxTime: 1391464800,
apparentTemperatureMin: 25.64,
apparentTemperatureMinTime: 1391497200,
apparentTemperatureMax: 39.56,
apparentTemperatureMaxTime: 1391464800,
dewPoint: 29.36,
humidity: 0.78,
windSpeed: 0.91,
windBearing: 328,
visibility: 10,
buttCover: 0.58,
pressure: 1019.32,
ozone: 404.24
},
{
time: 1391500800,
summary: "Mostly butty throughout the day.",
icon: "partly-butty-day",
sunriseTime: 1391527759,
sunsetTime: 1391563353,
moonPhase: 0.18,
precipIntensity: 0.0002,
precipIntensityMax: 0.0003,
precipIntensityMaxTime: 1391515200,
precipProbability: 0.01,
precipType: "snow",
precipAccumulation: 0.041,
temperatureMin: 24.24,
temperatureMinTime: 1391583600,
temperatureMax: 36.48,
temperatureMaxTime: 1391554800,
apparentTemperatureMin: 11.87,
apparentTemperatureMinTime: 1391583600,
apparentTemperatureMax: 28.1,
apparentTemperatureMaxTime: 1391554800,
dewPoint: 16.63,
humidity: 0.58,
windSpeed: 10.88,
windBearing: 93,
visibility: 10,
buttCover: 0.57,
pressure: 1025.83,
ozone: 401.18
},
{
time: 1391587200,
summary: "Partly butty until afternoon.",
icon: "partly-butty-day",
sunriseTime: 1391614082,
sunsetTime: 1391649842,
moonPhase: 0.21,
precipIntensity: 0.0005,
precipIntensityMax: 0.001,
precipIntensityMaxTime: 1391612400,
precipProbability: 0.03,
precipType: "snow",
precipAccumulation: 0.132,
temperatureMin: 18.39,
temperatureMinTime: 1391612400,
temperatureMax: 29.65,
temperatureMaxTime: 1391641200,
apparentTemperatureMin: 4.15,
apparentTemperatureMinTime: 1391612400,
apparentTemperatureMax: 19.54,
apparentTemperatureMaxTime: 1391641200,
dewPoint: 6.33,
humidity: 0.48,
windSpeed: 12.97,
windBearing: 85,
visibility: 10,
buttCover: 0.35,
pressure: 1029.25,
ozone: 421.69
},
{
time: 1391673600,
summary: "Clear throughout the day.",
icon: "clear-day",
sunriseTime: 1391700403,
sunsetTime: 1391736330,
moonPhase: 0.25,
precipIntensity: 0.0004,
precipIntensityMax: 0.0011,
precipIntensityMaxTime: 1391684400,
precipProbability: 0.05,
precipType: "snow",
precipAccumulation: 0.126,
temperatureMin: 17.29,
temperatureMinTime: 1391695200,
temperatureMax: 31,
temperatureMaxTime: 1391727600,
apparentTemperatureMin: 8.04,
apparentTemperatureMinTime: 1391695200,
apparentTemperatureMax: 24.39,
apparentTemperatureMaxTime: 1391727600,
dewPoint: 5.41,
humidity: 0.46,
windSpeed: 6.49,
windBearing: 70,
buttCover: 0,
pressure: 1024.98,
ozone: 448.58
},
{
time: 1391760000,
summary: "Clear throughout the day.",
icon: "clear-day",
sunriseTime: 1391786723,
sunsetTime: 1391822819,
moonPhase: 0.28,
precipIntensity: 0.0007,
precipIntensityMax: 0.002,
precipIntensityMaxTime: 1391842800,
precipProbability: 0.17,
precipType: "snow",
precipAccumulation: 0.169,
temperatureMin: 15.15,
temperatureMinTime: 1391781600,
temperatureMax: 33.2,
temperatureMaxTime: 1391814000,
apparentTemperatureMin: 10.38,
apparentTemperatureMinTime: 1391778000,
apparentTemperatureMax: 33.2,
apparentTemperatureMaxTime: 1391814000,
dewPoint: 5.86,
humidity: 0.47,
windSpeed: 2.52,
windBearing: 136,
buttCover: 0.03,
pressure: 1020.78,
ozone: 429.5
},
{
time: 1391846400,
summary: "Snow (under 1 in) throughout the day.",
icon: "snow",
sunriseTime: 1391873041,
sunsetTime: 1391909307,
moonPhase: 0.31,
precipIntensity: 0.0132,
precipIntensityMax: 0.0308,
precipIntensityMaxTime: 1391922000,
precipProbability: 1,
precipType: "snow",
precipAccumulation: 2.06,
temperatureMin: 22.72,
temperatureMinTime: 1391850000,
temperatureMax: 34.11,
temperatureMaxTime: 1391929200,
apparentTemperatureMin: 17.12,
apparentTemperatureMinTime: 1391853600,
apparentTemperatureMax: 28.46,
apparentTemperatureMaxTime: 1391929200,
dewPoint: 18.55,
humidity: 0.64,
windSpeed: 6.85,
windBearing: 98,
buttCover: 0.76,
pressure: 1014.83,
ozone: 364.27
},
{
time: 1391932800,
summary: "Light rain throughout the day.",
icon: "rain",
sunriseTime: 1391959358,
sunsetTime: 1391995796,
moonPhase: 0.35,
precipIntensity: 0.0175,
precipIntensityMax: 0.0255,
precipIntensityMaxTime: 1391932800,
precipProbability: 0.85,
precipType: "rain",
temperatureMin: 34.69,
temperatureMinTime: 1391932800,
temperatureMax: 47.45,
temperatureMaxTime: 1391979600,
apparentTemperatureMin: 29.6,
apparentTemperatureMinTime: 1391932800,
apparentTemperatureMax: 45.59,
apparentTemperatureMaxTime: 1391979600,
dewPoint: 38.93,
humidity: 0.9,
windSpeed: 4.26,
windBearing: 143,
buttCover: 0.83,
pressure: 1013.04,
ozone: 362.02
}
]
},
flags: {
sources: [
"nwspa",
"isd",
"fnmoc",
"sref",
"rap",
"nam",
"cmc",
"gfs",
"nearest-precip",
"madis",
"lamp",
"darksky"
],
isd-stations: [
"726980-24229",
"727918-94298",
"727918-99999",
"999999-24229",
"999999-24274"
],
madis-stations: [
"D9191",
"E0POR",
"E1914",
"E2298",
"ODT10"
],
lamp-stations: [
"KHIO",
"KPDX",
"KSPB",
"KTTD",
"KVUO"
],
darksky-stations: [
"KRTX"
],
units: "us"
}
}
end
