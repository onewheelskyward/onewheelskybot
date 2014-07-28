require 'httparty'
require 'json'

class UvIndex
  include Cinch::Plugin

  match /uv\s*(.*)$/i,                method: :uv_index

  set :help, <<-EOF
!uv[index] zipcode
  EOF

  def uv_index(msg, zip)
    snarky_replies = [
        'It\'s nighttime.',
        'Is it daybreak yet?',
        'Well, at least you can put away the flashlight.',
        '',
        '',
        '',
        '',
        '',
        'Better grab that spf30.',
        '',
        '',
        '']


    unless zip.match /^\d{5}$/
      # msg.reply "Sorry, #{msg.user.nick}, #{zip} doesn't look like a proper zip code Selecting Portland."
      zip = 97205
    end
    response = HTTParty.get("http://iaspub.epa.gov/enviro/efservice/getEnvirofactsUVHOURLY/ZIP/#{zip}/JSON")
    uv_indices = JSON.parse response.body
    uv_index = {value: 0, time: 0}
    uv_indices.each do |uv|
      if uv['UV_VALUE'] > uv_index[:value]
        uv_index[:value] = uv['UV_VALUE']
        uv_index[:time] = uv['DATE_TIME'][/\d{1,2}\s+[AP]M/].downcase
      end
    end
    # order
    # zip
    #date_time
    #uv_value
    msg.reply "Today's UV index will be #{uv_index[:value]} at #{uv_index[:time]}.  #{snarky_replies[uv_index[:value]]}"
  end
end
