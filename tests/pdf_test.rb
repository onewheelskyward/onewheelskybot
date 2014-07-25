require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require_relative 'test_helper'
require 'pdf-reader'

describe 'PDF Test' do

  before do
  end

  # common pattern, m.user.nick
  it 'stuff' do
    require 'open-uri'

    io     = open('http://www.olcc.state.or.us/pdfs/monthly_specials_c.pdf')
    reader = PDF::Reader.new(io)
    puts reader.info
    puts reader.pages.inspect
    # puts reader.pages.map(&:text)
    # puts reader.objects.inspect
    # reader.pages.each do |page|
      # puts page.inspect
    #   puts page.text
    #   puts page.raw_content
    # end
    receiver = PDF::Reader::RegisterReceiver.new
    reader.pages.each do |page|
      page.walk(receiver)
      receiver.callbacks.each do |cb|
        if cb[:name] == :begin_text_object
          puts "----"
        end
        if cb[:name] == :show_text
          puts "                                          " + cb[:args].to_s
        else
          puts cb
        end
        if cb[:name] == :end_text_object
          puts "----"
        end
      end
    end

  end
end
