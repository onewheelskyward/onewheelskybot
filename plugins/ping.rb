class Ping
  include Cinch::Plugin

  match /ping$/, method: :pong
  match /^ping$/, use_prefix: false, method: :pong

  set :help, <<-EOF
[!]ping PONG
  EOF

  def pong(msg)
    pong_images = %w( http://img209.imageshack.us/img209/366/toast.gif
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
                      http://25.media.tumblr.com/fa6c3e51a6464e202c351c607a4ea7b9/tumblr_mqpg9st8K71snfsquo1_400.gif
                      http://i.imgur.com/b0GVMNz.gif
                      http://www.doggifpage.com/gifs/109.gif
                      http://i.imgur.com/aVn5ABf.gif
                      http://swng.it/14ZqYT.gif
                      http://i.imgur.com/2PjC7RX.gif
                      http://i.imgur.com/82FbFvi.gif
                      https://dl.dropboxusercontent.com/u/575564/tumblr_mppsh4IaB81snfsquo1_400.gif
                      http://0.media.collegehumor.cvcdn.com/80/11/a5514aa0d1ad89720722b4fc12a9fe12.gif
                      http://media1.break.com/dnet/media/2013/3/29/3d7c8a6a-e7df-41f0-9526-038224f4baa5.gif
                    )
    msg.reply("#{pong_images.sample}")
  end
end