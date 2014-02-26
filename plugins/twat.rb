require 'nokogiri'
require 'httparty'

class Twitter
  include Cinch::Plugin

  match /(https:\/\/twitter.com\/\w+\/status\/\d+)/, use_prefix: false, method: :execute
  match /(https:\/\/twitter.com\/\w+)/, use_prefix: false, method: :execute_profile

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

  def execute_profile(msg, query)
    resp = HTTParty.get(query)
    noko = Nokogiri::HTML resp.body
    username_node = noko.css('span.username b')
    username = username_node[1].content # First <b> is blank.  /me shrugs
    profile_node = noko.css('p.profile-field')
    msg.reply "@#{username} #{profile_node[0].content}"
  end
end
