class UserStore
  include DataMapper::Resource

  property :id, Serial
  property :keything, String, length: 2222
  property :value, String, length: 2222
  property :user, String, length: 2222
  property :created_at, DateTime
  property :updated_at, DateTime
end
