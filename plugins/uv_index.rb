require 'httparty'
require 'json'

class UvIndex
  include Cinch::Plugin

  match /uvi*n*d*e*x*\s*(.*)$/i,                method: :uv_index
  match /uvula\s*(.*)$/i,                method: :uv_index

  set :help, <<-EOF
!uv[index] zipcode
  EOF

  def uv_index(msg, zip)
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
    msg.reply "Today's UV index will be #{uv_index[:value]} at #{uv_index[:time]}."
  end
end
