require 'open-uri'

def get_personalized_query(user, key, query)
  #location = get_location_from_zrobo(user)
  if query != ''
    UserStore.create(user: user, keything: key, value: query)
  else
    store = UserStore.last(user: user, keything: key)
    if store
      query = store.value
    end
  end
  query
end

def get_location_from_zrobo(user)
  # http://icecondor.com/donpdonp.json
end

def shorten_url(url, is_image = false)
  url
  #extension = nil
  #if url.scan /\.(jpg|png|gif|tiff)$/
  #  if $1
  #    extension = ".#{$1}"
  #  elsif is_image
  #    extension = '.jpg'  # Default no-extension handling.  I'm looking at you, cheezburger.
  #  end
  #end
  #g = HTTParty.get "http://is.gd/create.php?format=simple&url=#{URI::encode url}"
  #g.body + extension.to_s
end

def compress_string(str, compression_factor)
  i = 0
  rs = ''
  str.to_s.each_char do |char|
    if i % compression_factor == 0
      rs += char
    end
    i += 1
  end
  rs
end

def get_gps_coords(query)
  if @bot.is_a? Cinch::Test::MockBot
    return '45.55873,-122.77854'
  end
  query = 'Portland, OR' if query == ''
  if query =~ /\d+\.*\d*,\d+\.*\d*/
    return query
  end
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI.escape query}&sensor=false"
  puts url
  response = HTTParty.get url
  if response['results'].empty?
    return '0,0', 'Geocoder fail, Null Island'
  else
    return response['results'][0]['geometry']['location']['lat'].to_s + ',' + response['results'][0]['geometry']['location']['lng'].to_s, response['results'][0]['formatted_address']
  end
end

def get_gps_minutes_from_decimal(coord)
  degrees, decimal = coord.split /\./
  decimal = "0.#{decimal}".to_f
  return degrees.to_i, (decimal * 60).round(2)
end