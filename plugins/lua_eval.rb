require 'rufus/lua'

class LuaEval
  include Cinch::Plugin

  match /lua\s (.*)$/i, method: :execute #, react_on: :channel

  set :help, <<-EOF
[/msg] !lua [lua code]
  LUA code to eval.
  EOF

  def execute(msg, query)
    s = Rufus::Lua::State.new
    msg.reply s.eval query
  end
end
