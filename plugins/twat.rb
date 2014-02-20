require 'nokogiri'
require 'httparty'

class Twitter
  include Cinch::Plugin

  match /(https:\/\/twitter.com\/\w+\/status\/\d+)/, use_prefix: false, method: :execute

  set :help, <<-EOF
!twitter [url]
  EOF

  def execute(msg, query)
    resp = HTTParty.get(query)
    noko = Nokogiri::HTML resp.body
    username_node = noko.css('span.username b')
    username = username_node[1].content # First <b> is blank.  /me shrugs
    tweet_text_nodes = noko.css('p.tweet-text') # .each here gives the whole conversation.
    msg.reply "@#{username} #{tweet_text_nodes[0].content}"
  end
end
