###
# We're nowhere on this.
##
require 'json'
require '3scale_client'

class ThreeTaps
  include Cinch::Plugin

  match /3taps\s+(.*)$/i,                method: :execute

  set :help, <<-EOF
!3scale [query]
  EOF

  def execute(msg, query)
# keep your provider key secret
    client = ThreeScale::Client.new(:provider_key => '2e505d477d7d286b90995dc03ec9e8d1' )
# 74074cbdbae0f531bf0a14754264fe12
# you will usually obtain app_id and app_key from request params
    response = client.authrep( :user_key => 'ec6358ede0f2dc9ab43ae9907a99bf81' ,
                               :usage => { :hits => 1 })

    if response.success?
      x = "Application authorized and hit reported!"
    else
      x = "Error: #{response.error_message}"
    end

    msg.reply x
  end
end
