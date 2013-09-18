require 'rspec'
require 'cinch/test'
require 'data_mapper'
Dir.glob("plugins/*.rb").each { |file| require_relative file }

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
DataMapper.auto_migrate!

#make_bot(plugin, plugin_opts)
include Cinch::Test
bot = make_bot(Images)

describe "stuff" do
  message = make_message(bot, 'image me yyz')
  replies = get_replies(message)
  puts message.inspect
  puts replies.inspect
end
