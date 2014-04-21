require 'json'
require 'httparty'
require 'nokogiri'
require_relative '../helpers'

class MoonPhase
  include Cinch::Plugin

  match /moon\s*(.*)$/i, method: :execute

  set :help, <<-EOF
Moon phase and civil twilight information.
  EOF

  def get_usno_navy_mil_data(gps_coords)
    lat, long = gps_coords.split /,/
    lat_degrees, lat_minutes = get_gps_minutes_from_decimal lat
    long_degrees, long_minutes = get_gps_minutes_from_decimal long

    lat_negative = is_negative(lat_degrees)
    long_negative = is_negative(long_degrees)

    if bot.is_a? Cinch::Test::MockBot
      str = "        Monday   \n        21 April 2014         Universal Time - 7h            \n                         <strong>SUN</strong>        Begin civil twilight      05:42                 \n        Sunrise                   06:13                 \n        Sun transit               13:07                 \n        Sunset                    20:01                 \n        End civil twilight        20:33                 \n                         <strong>MOON</strong>\n        Moonset                   10:36 on preceding day\n        Moonrise                  01:40                 \n        Moon transit              06:39                 \n        Moonset                   11:42                 \n        Moonrise                  02:23 on following day\n"
    else
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
      str = noko.css('pre').children.text
    end

    whackadoo = {}
    str.split(/\n/).each do |element|
      if element.scan /^\s+([\w\s]+)\s+(\d+:\d+)/
        if $2
          whackadoo[$1.strip] = $2
        end
      end
    end
    whackadoo
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
