require 'rspec'
#require 'cinch/test'
#require 'data_mapper'
#Dir.glob("plugins/*.rb").each { |file| require_relative file }
require 'tzinfo'
#DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, "sqlite::memory:")
#DataMapper.finalize
#DataMapper.auto_migrate!

#make_bot(plugin, plugin_opts)
#include Cinch::Test

describe "Bot specs" do
  #it "will search google for images" do
  #  bot = make_bot(Images)
  #  message = make_message(bot, '!image me yyz')
  #  replies = get_replies(message)
  #  puts message.inspect
  #  puts replies.inspect
  #end
  #
  #it "will search wolfram for pi" do
  #  bot = make_bot(Wolfram, {wolfram_url: 'http://api.wolframalpha.com/v1/query?input=', wolfram_appid: 'LH99EJ-YTE6LQU6VJ'})
  #  message = make_message(bot, '!alpha pi')
  #  replies = get_replies(message)
  #  puts message.inspect
  #  puts replies.inspect
  #end
  it 'x' do
    date = DateTime.now
    puts date.to_s
    date = DateTime.now - 1
    puts date.to_s
  end
  it 'y' do
    date = DateTime.now
    puts
    puts (Time.now - 25200).strftime('%H:%M').to_s
    puts ((Time.now + 3600).strftime('%H:%M')).to_s
    tz = TZInfo::Timezone.get('America/Los_Angeles')
    puts tz.utc_to_local(Time.now.utc).to_s
  end
end
