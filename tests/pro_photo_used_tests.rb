require_relative 'test_helper'
require_relative '../plugins/pro_photo_used'

describe 'this' do
  include Cinch::Test
  let(:bot) { make_bot(ProPhotoUsed, :foo => 'foo_value') }

  it 'makes a test bot with a config' do
    bot.is_a?(Cinch::Bot).should == true
  end

  it 'Checks the prophoto used' do
    message = make_message(bot, '!prophoto hasselblad')
    replies = get_replies(message)
    replies[0].text.should == ': rise 01:40, transit 06:39, set 11:42'
  end
end
