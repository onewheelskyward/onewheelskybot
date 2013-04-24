require 'rspec'
require_relative 'helpers'

DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, "sqlite::memory:")
DataMapper.setup(:default, "postgres://localhost/beers")
DataMapper.finalize
DataMapper.auto_migrate!

describe "stuff" do
end
