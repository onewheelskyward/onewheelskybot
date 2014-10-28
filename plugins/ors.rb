###
# Work in progress.  There's so much data, it's hard to display reasonably in IRC.
##
# require 'json'
# require 'httparty'
#require

class ORS
  include Cinch::Plugin

  match /ors\s*(\d+\.\d+)$/i, method: :execute

  set :help, <<-EOF
This will simply redirect you to oregonlaws.org.
!ors xxx.xxx
  EOF

  def execute(msg, query)
      msg.reply "http://www.oregonlaws.org/ors/#{query}"
  end
end
