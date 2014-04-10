# = Cinch Wolfram Alpha Plugin
#
# This plugin is useful if you want to run Cinch as a daemon
# process. It creates a file containing Cinch’s process
# identifier (PID) when connecting to an IRC server, and deletes
# it on disconnection.
#
# == Dependencies
# None.
#
# == Configuration
# Add the following to your bot’s configure.do stanza:
#
#   config.plugins[Cinch::PidFile] = {
#     :path   => "/run/orrbot.pid,
#     :strict => true
#   }
#
# [path]
#   Where you want to have the PID file created. The directory
#   must be writable by Cinch.
# [strict (true)]
#   If this is true (the default), Cinch will refuse to start
#   if the PID file already exists, as this usually means that
#   another instance of Cinch is already running, but this may
#   also be the result of a kill-9 or the like. If you don’t
#   want this behaviour, simply set this option to false.
#
# == Author
# Andrew Kreps
#
# == License
# GPL v3
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright © 2014 Andrew Kreps

require 'mechanize'
require 'open-uri'
require 'json'
require 'nokogiri'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative '../models/api_request'

class Wolfram
  include Cinch::Plugin
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "postgres://localhost/skybot")
  DataMapper.finalize
  ApiRequest.auto_upgrade!

  #listen_to :message, :method => :on_connect
  #match /help(.*)/i, :use_prefix => false, :react_on => :private
  match /alpha\s*m*e*\s(.*)/i, method: :wolfram_alpha_search #, react_on: :channel
  match /sunrise$/i, method: :sunrise
  match /sunset$/i, method: :sunset
  match /moonrise$/i, method: :moonrise
  match /moonset$/i, method: :moonset
  match /moonphase$/i, method: :moonphase

  set :help, <<-EOF
!alpha <search term>  Wolfram Alpha computational search.
!sunrise   Next sunrise in PDX.
!sunset    Next sunset in PDX.
!moonrise  Next moonrise in PDX.
!moonset   Next moonset in PDX.
!moonphase Current moon phase in PDX.
  EOF

  def get_app_id
    "&appid=" + config[:wolfram_appid]
  end

  def query_wolfram_alpha(query)
    url = config[:wolfram_url] + URI::encode(query) + get_app_id

    agent = Mechanize.new
    request = agent.get(url)
    request.body
  end

  def parse_search_result(xml)
    xml_doc = Nokogiri::XML xml

    xml_doc.xpath("//pod").each_with_index do |pod, index|
      if index == 1
        element = pod.xpath("subpod").first
        p element
        plaintext = element.xpath("plaintext").children.to_s
        if plaintext == ""
          plaintext = element.xpath("img").attr("src").to_s
        end
        return plaintext
      end
    end


    if futuretopic = xml_doc.xpath("//futuretopic").first
      return futuretopic.attr("msg")
    end
    # If the query fails, wolfram often finds something else relevant.
    if didyoumean = xml_doc.xpath("//didyoumean").first
      return "Did you mean #{didyoumean.children.to_s}?"
    end
  end

  def wolfram_alpha_search(msg, query)
    # Check cache.
    #req = ApiRequest.first_or_create(type: :wolfram, request: query)
    req = ApiRequest.create(type: :wolfram, request: query)
    #if req.reply
    #  reply = parse_search_result(req.response)
    #  msg.reply("* #{reply}")
    #else
      xml = query_wolfram_alpha(query)
      req.response = xml
      reply = parse_search_result(xml)
      req.reply = reply.to_s.gsub "\n", "  /  "
      req.save
    msg.reply req.reply
    #end
  end

  def sunrise(msg)
    reply = wolfram_alpha_search(msg, 'sunrise pdx')
    hh, mm, ss = get_hms_until_date(reply)
    msg.reply reply + ", #{hh} hours, #{mm} minutes and #{ss} seconds from now."
  end

  def get_hms_until_date(date_str)
    date = DateTime.parse(date_str)
    date_diff_in_days = (date - DateTime.now()).to_f
    date_diff_in_seconds = (date_diff_in_days * 24 * 60 * 60).to_i
    mm, ss = date_diff_in_seconds.divmod(60) #=> [4515, 21]
    hh, mm = mm.divmod(60) #=> [75, 15]
    dd, hh = hh.divmod(24)
    return hh, mm, ss
  end

  def sunset(msg)
    reply = wolfram_alpha_search(msg, 'sunset pdx')
    date = DateTime.parse(reply)
    hh, mm, ss = get_hms_until_date(reply)
    msg.reply reply + ", #{hh} hours, #{mm} minutes and #{ss} seconds from now."
  end

  def moonrise(msg)
    reply = wolfram_alpha_search(msg, 'moonrise pdx')
    date = DateTime.parse(reply)
    hh, mm, ss = get_hms_until_date(reply)
    msg.reply reply + ", #{hh} hours, #{mm} minutes and #{ss} seconds from now."
  end

  def moonset(msg)
    reply = wolfram_alpha_search(msg, 'moonset pdx')
    date = DateTime.parse(reply)
    hh, mm, ss = get_hms_until_date(reply)
    msg.reply reply + ", #{hh} hours, #{mm} minutes and #{ss} seconds from now."
  end

  def moonphase(msg)
    reply = wolfram_alpha_search(msg, 'moon phase pdx')
    msg.reply reply
  end
end
