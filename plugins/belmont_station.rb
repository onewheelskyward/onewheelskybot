###
# Work in progress.  There's so much data, it's hard to display reasonably in IRC.
##
require 'json'
require 'httparty'
#require

class BelmontStation
  include Cinch::Plugin

  match /belmont\s*(.*)$/i, method: :execute

  set :help, <<-EOF
This will search for bottles at Belmont Station.
!belmont [search terms]
  EOF

  def persist_list
    belmont_bottles = HTTParty.get('http://www.belmont-station.com/index.php?id=bottles')
    bonoko = Nokogiri::HTML(belmont_bottles.body)
    bonoko.css('table#mainTable tr').each do |m|
      beer = type = where = nil
      m.children.each_with_index do |td, index|
        case index
          when 0
            beer = td.children.to_s.strip
          when 2
            where = td.children.to_s.strip
          when 4
            type = td.children.to_s.strip
        end
      end
      # persist here if not nil
    end
  end

  def check_for_expiration

  end

  def execute(msg, query)
      puts "#{beer} a #{type} beer from #{where}"
      if beer.downcase.include? query.downcase or type.downcase.include? query.downcase or where.downcase.include? query.downcase
        msg.reply "#{beer} a #{type} beer from #{where}"
      end
  end
end
