#################
# Taken from http://github.com/cinchrb/cinch
###

#if ENV["SIMPLECOV"]
#  begin
    require 'simplecov'
    SimpleCov.start
  #rescue LoadError
  #end
#end

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
