class Private
  include Cinch::Plugin
  #listen_to :private, method: private
  match /say\s(#.*)\s(.*)$/, method: :say
  #on :private do |m, q|
  #  debug("#{q}")
  #end

  def say(msg, channel, thing)
    if msg.user == config[:master_user]
      Channel(channel).send(thing)
    end
  end

  def private(msg, q)

  end
end
