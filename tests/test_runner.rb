require 'simplecov'
SimpleCov.start

require 'cinch/test'
require 'timecop'
require_relative 'test_helper'

Dir.glob('tests/*_tests.rb').each do |file|
  puts file.sub 'tests/', ''
  require_relative file.sub 'tests/', ''
end
