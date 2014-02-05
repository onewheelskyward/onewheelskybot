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
  extension = nil
  if url.scan /\.(jpg|png|gif|tiff)$/
    if $1
      extension = ".#{$1}"
    elsif is_image
      extension = '.jpg'  # Default no-extension handling.  I'm looking at you, cheezburger.
    end
  end
  g = HTTParty.get "http://is.gd/create.php?format=simple&url=#{URI::encode url}"
  g.body + extension.to_s
end
