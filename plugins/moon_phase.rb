require 'json'
require 'httparty'
require 'nokogiri'
require_relative '../helpers'

class MoonPhase
  include Cinch::Plugin

  match /mp\s*(.*)$/i,                method: :execute

  set :help, <<-EOF
Moon phase and civil twilight information.
  EOF

  def get_usno_navy_mil_data(gps_coords)
    lat, long = gps_coords.split /,/
    lat_degrees, lat_minutes = get_gps_minutes_from_decimal lat
    long_degrees, long_minutes = get_gps_minutes_from_decimal long

    lat_negative = is_negative(lat_degrees)
    long_negative = is_negative(long_degrees)

    resp = HTTParty.post('http://aa.usno.navy.mil/cgi-bin/aa_pap.pl', :body => {
    'FFX' => 2,
    'ID' => 'SKYBOT',
    'xxy' => Time.now.year,
    'xxm' => Time.now.month,
    'xxd' => Time.now.day,
    'place' => '(no name given)',
    'xx0' => long_negative,
    'xx1' => long_degrees,
    'xx2' => long_minutes, #minutes
    'yy0' => lat_negative,
    'yy1' => lat_degrees,
    'yy2' => lat_minutes, # minutes
    'zz1' => 7, #timezone
    'zz0' => -1, #timezone negative most likely
    'ZZZ' => 'END' #idaknow
    })
    noko = Nokogiri::HTML resp.body
    noko.css('pre').children
  end

  def is_negative(degrees)
    negative = 1
    if degrees < 1
      negative = -1
    end
    negative
  end

  def execute (msg, query)
    coords = get_gps_coords(query)
    data = get_usno_navy_mil_data coords
    msg.reply data
  end
end
