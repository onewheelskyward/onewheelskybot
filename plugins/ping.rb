class Ping
  include Cinch::Plugin

  match /ping$/, method: :pong
  match /^ping$/, use_prefix: false, method: :pong

  set :help, <<-EOF
[/msg] ping
  pong
  EOF

  def pong(msg)
    pong_images = %w(http://img209.imageshack.us/img209/366/toast.gif
                     http://i.imgur.com/cRgZZca.gif
                     https://dl.dropboxusercontent.com/u/575564/apecgnU.gif
                     http://i.imgur.com/1LG3p1Q.gif
                     http://cdn.memegenerator.net/instances/500x/43965451.jpg
                     http://30.media.tumblr.com/tumblr_m3056cCdb71rr3l61o1_500.gif
                     http://giphy.com/gifs/Us2YBZNhO8Pba/tiled
                     http://media.giphy.com/media/2WhCMpG85VhWE/giphy.gif
                     http://media.giphy.com/media/rUCzODGkQF8GY/giphy.gif
                     http://i.imgur.com/SbW8sEh.gif
                     http://i.imgur.com/2mBqBxw.jpg
                     http://i.imgur.com/YTC0CEK.gif
                     http://swng.it/uYr6s.gif
                     http://www.youtube.com/watch?v=Xb5iqUhC-kA
                    )
    msg.reply("#{pong_images.sample}")
  end
end