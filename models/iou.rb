class IOU
  include DataMapper::Resource

  property :id, Serial
  property :type, Enum[:beer], default: :beer
  property :ower, String, length: 312
  property :owee, String, length: 312
  property :status, Enum[:owed, :paid], default: :owed
  property :created_at, DateTime
  property :updated_at, DateTime
end
