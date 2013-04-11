require 'mechanize'
require 'open-uri'
require 'JSON'

def grab_baileys
  url = 'http://api.legitimatesounding.com/api/baileys'
  JSON.parse open(url).read
  #agent = Mechanize.new
  #page = agent.get()
  #noko = Nokogiri.HTML(page.body)

end
