require_relative 'test_helper'
require_relative '../plugins/forecast_io'
require 'httparty'

describe 'forecastio controller tests' do
  include Cinch::Test
  let(:bot) { make_bot(ForecastIO, :foo => 'foo_value') }

  it 'tests the texts' do
    HTTParty.get('http://localhost:6207/forecast')
    "x".should == "y"
  end

end
