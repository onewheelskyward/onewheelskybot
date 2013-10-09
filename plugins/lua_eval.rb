require 'rufus/lua'

class LuaEval
  include Cinch::Plugin

  match /lua\s(.*)$/i, method: :execute #, react_on: :channel

  set :help, <<-EOF
[/msg] !lua [lua code]
  LUA code to eval.
  EOF

  def execute(msg, query)
    s = Rufus::Lua::State.new
    begin
      result = s.eval query
    rescue Exception => e
      result = e.message
    end
    msg.reply result
  end
end
