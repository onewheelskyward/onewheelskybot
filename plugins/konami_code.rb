class KonamiCode
  include Cinch::Plugin

  match /^\^\^vv\<\>\<\>\b\a\s\t\a\r\t$/i, prefix: nil, method: :execute #, react_on: :channel

  set :help, <<-EOF
  EOF

  def execute(msg)
    msg.reply "30 lives granted."
  end
end
