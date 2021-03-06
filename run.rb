require 'data_mapper'
Dir.glob("models/*.rb").each { |model| require_relative model }
DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
DataMapper.auto_migrate!

require_relative 'bot'
