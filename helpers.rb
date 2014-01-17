
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
