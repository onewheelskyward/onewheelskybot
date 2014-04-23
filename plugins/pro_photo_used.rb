require 'json'
require 'httparty'
require 'nokogiri'
require_relative '../helpers'

class ProPhotoUsed
  include Cinch::Plugin

  match /prophoto\s+(.*)$/i, method: :execute

  set :help, <<-EOF
!prophoto
Pro photo used search
  EOF

  def get_pro_photo_data()

    resp = HTTParty.get('http://prophotosupply.com/p-used.htm')
    noko = Nokogiri::HTML resp.body
    search_db = {}
    search_db[:cameras] = get_elements(noko, 'cameras')
    search_db[:lens] = get_elements(noko, 'lens')
    search_db[:flash] = get_elements(noko, 'flash')
    search_db[:studio] = get_elements(noko, 'studio')
    search_db[:stands] = get_elements(noko, 'stands')
    search_db[:tripod] = get_elements(noko, 'tripod')
    search_db[:computers] = get_elements(noko, 'computers')
    search_db[:accessories] = get_elements(noko, 'accessories')
    search_db[:misc] = get_elements(noko, 'misc')
    search_db
  end

  def get_elements(noko, id_str)
    elements = []
    noko.css("##{id_str} table").children.each do |tr|
      elem = {}
      # table.xpath('//table/tr').each do |tr|
      elem[:item] = tr.at_xpath('td[2]/text()').to_s
      elem[:price] = tr.at_xpath('td[3]/text()').to_s

      unless elem[:item].empty?
        elements.push elem
      end
    end
    elements
  end

  def execute (msg, query)
    results = false
    search_db = get_pro_photo_data
    search_db.keys.each do |elements|
      arr = search_db[elements]
      arr.each do |element|
        if element[:item].downcase.include? query.downcase
          results = true
          User(msg.user.nick).send("#{elements}: #{element[:item]} $#{element[:price]}")
        end
      end
    end
    unless results
      msg.reply "Nothing found for '#{query}'"
    end
  end
end
