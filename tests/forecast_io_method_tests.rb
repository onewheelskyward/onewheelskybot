require_relative '../plugins/forecast_io'
require_relative '../helpers'
require_relative 'test_helper'

describe 'this' do
  include Cinch::Test
  let(:bot) { make_bot(ForecastIO, :foo => 'foo_value') }

  it 'makes a test bot with a config' do
    bot.is_a?(Cinch::Bot).should == true
  end

  it 'tries the forecast' do
    message = make_message(bot, '!forecast')
    replies = get_replies(message)
    replies[0].text.should == ' weather is currently 56.89°F and partly cloudy.  Winds out of the N at 2.42 mph. It will be partly cloudy for the hour, and light rain tomorrow evening.  There are also 317.73 ozones.'
  end

  it 'tries the weather' do
    message = make_message(bot, '!weather')
    replies = get_replies(message)
    replies[0].text.should == ' weather is currently 56.89°F and partly cloudy.  Winds out of the N at 2.42 mph. It will be partly cloudy for the hour, and light rain tomorrow evening.  There are also 317.73 ozones.'
  end

  it 'tries the weather c' do
    message = make_message(bot, '!weather set scale c')
    message = make_message(bot, '!weather')
    replies = get_replies(message)
    replies[0].text.should == ' weather is currently 56.89°F and partly cloudy.  Winds out of the N at 2.42 mph. It will be partly cloudy for the hour, and light rain tomorrow evening.  There are also 317.73 ozones.'
  end

  it 'drives out some ascii temps' do
    message = make_message(bot, '!asciitemp')
    replies = get_replies(message)
    replies[0].text.should == " temps: now 58.8°F |\u000311*~\u000F\u000309~~~-._..-~\u000F\u000311~**'''\u000F\u000308'\u000F\u000311'''*~\u000F| 55.9°F this hour tomorrow.  Range: 47.6°F - 65.0°F"
  end

  it 'drives out some ansi temps' do
    message = make_message(bot, '!ansitemp')
    replies = get_replies(message)
    replies[0].text.should == " temps: now 58.8°F |11▇▅09▅▅▅▃▁_▁▁▃▅11▅▇▇███08█11███▇▅| 55.9°F this hour tomorrow.  Range: 47.6°F - 65.0°F"
  end

  it 'displays ansisun' do
    message = make_message(bot, '!ansisun')
    replies = get_replies(message)
    replies[0].text.should == " 8 day sun forecast |\u000307▅\u000F\u000309_\u000F\u000307▅\u000F\u000308███▇\u000F\u000309▃\u000F|"
  end

  it 'displays asciisun' do
    message = make_message(bot, '!asciisun')
    replies = get_replies(message)
    replies[0].text.should == " 8 day sun forecast |\x0307~\x0F\x0309_\x0F\x0307~\x0F\x0308'''*\x0F\x0309-\x0F|"
  end

  it 'sets the scale' do
    message = make_message(bot, '!forecast set scale f')
    replies = get_replies(message)
    replies[0].text.should == 'test: Temperature scale set to f'
  end

  it 'sets the scale' do
    message = make_message(bot, '!forecast set scale c')
    replies = get_replies(message)
    replies[0].text.should == 'test: Temperature scale set to c'
  end

  it 'checks the ozone' do
    message = make_message(bot, '!asciiozone')
    replies = get_replies(message)
    replies[0].text.should == ' ozones 317.54 |◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◉◉◉◉◉◉◉◉◉◉◉◉◉◉??????????????◉◉◉◉◉| 343.95 [24h forecast]'
  end

  it 'fires off asciirain' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!asciirain')
      replies = get_replies(message)
      replies[0].text.should == " rain probability 22:32|\x0302_.\x0F\x0306-\x0F\x0310~\x0F\x0303~\x0F\x0309~\x0F\x0311*\x0F\x0308*\x0F\x0307'\x0F\x0304'\x0F\x0313'\x0F\x0302__________________________________________________\x0F|23:32"
    end
  end

  it 'lights up ansirain' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!ansirain')
      replies = get_replies(message)
      replies[0].text.should == " rain probability 22:32|\u000302_▁\u000F\u000306▃\u000F\u000310▅\u000F\u000303▅\u000F\u000309▅\u000F\u000311▇\u000F\u000308▇\u000F\u000307█\u000F\u000304█\u000F\u000313█\u000F\u000302__________________________________________________\u000F|23:32"
    end
  end

  it 'fires off asciirain intensity' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!asciirain intensity')
      replies = get_replies(message)
      replies[0].text.should == " rain intensity 22:32|\x0302_\x0F\x0306.\x0F\x0310.\x0F\x0303.\x0F\x0309.\x0F\x0311.\x0F\x0308.\x0F\x0307.\x0F\x0304.\x0F\x0313.'\x0F\x0302__________________________________________________\x0F|23:32"
    end
  end

  it 'lights up ansirain intensity' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!ansirain intensity')
      replies = get_replies(message)
      replies[0].text.should == " rain intensity 22:32|\u000302_\u000F\u000306▁\u000F\u000310▁\u000F\u000303▁\u000F\u000309▁\u000F\u000311▁\u000F\u000308▁\u000F\u000307▁\u000F\u000304▁\u000F\u000313▁█\u000F\u000302__________________________________________________\u000F|23:32"
    end
  end

  it 'asciiwind' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!asciiwind')
      replies = get_replies(message)
      replies[0].text.should == " 24h wind speed 2.52 mph |\x0302--------.._.-\x0F\x0306~~~*\x0F\x0310*'''*\x0F\x0306*~~~~~~~\x0F\x0302-----\x0F\x0306~~~*\x0F\x0310**''''*\x0F\x0306*~~\x0F| 4.69 mph  Range: 1.59 - 8.61 mph"
    end
  end

  it 'asciiwind dir' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!asciiwind dir')
      replies = get_replies(message)
      replies[0].text.should == " 24h wind direction |\u000302↓↓↙←↖↗↑↑↑↑↑↗↗\u000F\u000306→→↗→\u000F\u000310→→→→↘\u000F\u000306↘↘\u000F| Range: 1.59 - 8.61 mph"
    end
  end

  it 'ansiwind' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!ansiwind')
      replies = get_replies(message)
      replies[0].text.should == " 24h wind speed 2.52 mph |\u000302▃▃▃▃▃▃▃▃▁▁_▁▃\u000F\u000306▅▅▅▇\u000F\u000310▇███▇\u000F\u000306▇▅▅▅▅▅▅▅\u000F\u000302▃▃▃▃▃\u000F\u000306▅▅▅▇\u000F\u000310▇▇████▇\u000F\u000306▇▅▅\u000F| 4.69 mph  Range: 1.59 - 8.61 mph"
    end
  end

  it 'ansiwind dir' do
    Timecop.freeze(2014, 04, 07, 22, 32, 00) do
      message = make_message(bot, '!ansiwind dir')
      replies = get_replies(message)
      replies[0].text.should == " 24h wind direction |\u000302↓↓↙←↖↗↑↑↑↑↑↗↗\u000F\u000306→→↗→\u000F\u000310→→→→↘\u000F\u000306↘↘\u000F| Range: 1.59 - 8.61 mph"
    end
  end
end
