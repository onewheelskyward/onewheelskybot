class ApiRequest
  include DataMapper::Resource

  property :id, Serial
  property :type, Enum[:image, :wolfram]
  property :request, String, length: 4000
  property :response, Text
  property :reply, String, length: 4000
  property :created_at, DateTime
  property :updated_at, DateTime
end
