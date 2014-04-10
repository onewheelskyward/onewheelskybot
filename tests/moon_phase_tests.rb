require_relative '../plugins/moon_phase'

describe 'this' do
  include Cinch::Test
  let(:bot) { make_bot(MoonPhase, :foo => 'foo_value') }

  it 'makes a test bot with a config' do
    bot.is_a?(Cinch::Bot).should == true
  end

  it 'Checks the portland moon phase' do
    message = make_message(bot, '!mp Portland, OR')
    replies = get_replies(message)
    replies[0].should == ' '
  end

  # it 'lights up ansirain intensity' do
  #   Timecop.freeze(2014, 04, 07, 22, 32, 00) do
  #     message = make_message(bot, '!ansirain intensity')
  #     replies = get_replies(message)
  #     replies[0].should == " rain intensity 22:32|\u000302_\u000F\u000306▁\u000F\u000310▁\u000F\u000303▁\u000F\u000309▁\u000F\u000311▁\u000F\u000308▁\u000F\u000307▁\u000F\u000304▁\u000F\u000313▁█\u000F\u000302__________________________________________________\u000F|23:32"
  #   end
  # end
end
