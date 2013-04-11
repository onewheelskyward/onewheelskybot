require 'rspec'
require_relative 'helpers'

describe "stuff" do
  it "should" do
    x = grab_baileys
    x['status'].should == "ok"
  end
end
