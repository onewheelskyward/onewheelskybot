require 'simplecov'
SimpleCov.start

require 'data_mapper'

Dir.glob(File.dirname(__FILE__) + "/../models/*.rb").each { |model| require_relative model }
DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
DataMapper.setup(:default, "postgres://localhost/skybot_test")
DataMapper.finalize
DataMapper.auto_migrate!

#unless Object.const_defined? 'Cinch'
#  $:.unshift File.expand_path('../../lib', __FILE__)
#  require 'cinch'
#end

#require 'minitest/autorun'

#class TestCase < MiniTest::Test
#  def self.test(name, &block)
#    define_method("test_" + name, &block) if block
#  end
#end
