require_relative '../helpers'

describe 'GPS functions test' do
  include Cinch::Test

  it 'will calc minutes from degrees' do
    degrees, minutes = get_gps_minutes_from_decimal('45.0166667')
    degrees.should == 45
    minutes.should == 1
  end

  it 'will calc 59 minutes from degrees' do
    degrees, minutes = get_gps_minutes_from_decimal('-122.9834')
    degrees.should == -122
    minutes.should == 59
  end

end
