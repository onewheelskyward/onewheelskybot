class RubyEval
  include Cinch::Plugin

  match /(.*)$/i, prefix: '>>', method: :execute #, react_on: :channel

  set :help, <<-EOF
[/msg] >> [ruby code]
  ruby code to eval.
  EOF

  def execute(msg, query)

    msg.reply eval query
  end
end
