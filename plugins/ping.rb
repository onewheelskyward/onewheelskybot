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
                      http://gifs.gifbin.com/082013/1377796061_cat_gets_a_massage.gif
                      http://i.imgur.com/UaNm6fv.gif
                      http://i.imgur.com/RgTu8yb.gif
                      https://github-camo.global.ssl.fastly.net/4ba69a537791f9b79584abccf4b6a925d397acbc/687474703a2f2f6d656469612e67697068792e636f6d2f6d656469612f575257396463645933663839572f67697068792e676966#.png
                      http://img.imgur.com/Ga5GtAM.gif
                      http://www.hdpaperwall.com/wp-content/uploads/2013/11/sad_dog.jpg
                      https://i.chzbgr.com/maxW500/1087527680/h0403FA19.jpg
                      http://www.stupid.com/assets/images/JRCC_1.jpg
                      https://lh6.googleusercontent.com/-KaoDXtxBeBw/UvTxrt7hZqI/AAAAAAAAph4/_fTAcb_9lRI/w280-h154-no/EvolutionDoor.gif
                      http://i.imgur.com/tJKlWOL.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/u.s.-open-bird-man-videobombs-costas.gif
                      https://f.cloud.github.com/assets/937626/2140770/b384be2c-9350-11e3-83e0-374c2b646829.jpg
                      http://i.imgur.com/JTW4cle.jpg
                      http://www.totalprosports.com/wp-content/uploads/2012/12/sports-reporter-almost-run-over-by-car.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/jay-onrait-jazz-hands-gif.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/towel-thrown-on-courtside-reporters-head.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/reporter-hit-in-head-with-soccer-ball.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/ian-hit-with-football.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/shaq-attacking-pinata-1.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/shaq-attacking-pinata-2.gif
                      http://www.totalprosports.com/wp-content/uploads/2012/12/Jessica-Kastrop-Hit-in-the-Head-with-Soccer-Ball.gif
                      http://oi40.tinypic.com/215y1d.jpg
                      http://blog.evaria.com/wp-content/uploads/2008/02/nuns-with-legs.jpg
                      http://www.ivorytowertutoring.com/blog/wp-content/uploads/2011/12/butt-chair.jpg
                      http://i.imgur.com/EXHo2Ag.gif
                      https://f.cloud.github.com/assets/2894119/2172154/45e89dca-958f-11e3-86a0-63c60967148f.gif
                      http://assets.inhabitat.com/wp-content/blogs.dir/1/files/2011/10/Blinky-e1319824451193.jpg
                      http://i0.kym-cdn.com/photos/images/original/000/120/151/space_core_wallpaper_2_by_deathonabun-d3eta23.jpg
                      http://i.imgur.com/v1TyHu8.jpg
                      https://dl.dropboxusercontent.com/u/55631203/700_9162-MOTION.gif
                      https://d3j5vwomefv46c.cloudfront.net/photos/large/839385081.gif
                      http://31.media.tumblr.com/tumblr_lgq7ygJyck1qdgq6go1_250.gif
                      http://i.imgur.com/eVlTtRy.gif
                      http://i.imgur.com/civQQne.gif
                      http://a.gifb.in/g60050g6868.gif
                      https://i.chzbgr.com/maxW500/8068878848/h0B8447D2/
                      http://i.imgur.com/aleMzyT.gif
                      http://weknowmemes.com/wp-content/uploads/2012/06/i-dont-always-poo-holy-shit.jpg
                      http://i.imgur.com/tQBVFkV.gif
                      http://pbs.twimg.com/media/BhQkaF4CcAADpxY.jpg
                      http://i.imgur.com/JMXus92.gif
                      http://www.dogster.com/files/Audrey_Baby_Bjorn_Rusty_2.jpg
                      http://cl.ly/image/1P372A1U4316/dkwyjs.gif
                      http://i.imgur.com/h3N15C2.gif
                      http://i.imgur.com/0uDd2Z5.gif
                      http://kontraband.se/blog/wp-content/uploads/2009/08/st1.gif
                      http://pauloliverfpblog.files.wordpress.com/2013/05/banging-head.gif
                      https://lh3.googleusercontent.com/-ZRuuQPYHm4s/Uw4Euht_IQI/AAAAAAAAiig/LNMIBDyvVXY/w421-h288-no/Man+disguised+as+a+speed+camera+flashes+as+cars+drive+by+%2528medias.omgif.net%2529.gif
                      http://i.imgur.com/AzS1hgd.gif
                      https://mail.google.com/mail/u/1/?ui=2&ik=cef0db8d39&view=att&th=144899510f2a72c4&attid=0.1&disp=emb&realattid=ii_1448994d8d1f1a16&zw&atsh=1
                      http://www.doggifpage.com/gifs/116.gif
                      http://24.media.tumblr.com/dc361833d0a5ddb4bc8f14c5f76719f8/tumblr_n1wme9Ziti1qdlh1io1_400.gif
                      http://i.imgur.com/SIngIEm.jpg
                      http://i.imgur.com/mIeNbA2.gif
                  )
    if msg.user.nick == 'incanus77'
      pong = %w(
                 'http://i.imgur.com/JTW4cle.jpg',
                 'https://f.cloud.github.com/assets/5572214/2140070/38283e06-9347-11e3-85a8-78b30b2f5701.JPG',
                 'https://f.cloud.github.com/assets/32314/2140406/00e89698-934c-11e3-9235-a8feb82e77fc.png',
                 'https://f.cloud.github.com/assets/937626/2140770/b384be2c-9350-11e3-83e0-374c2b646829.jpg',
                 'https://f.cloud.github.com/assets/26278/2140782/cd459340-9350-11e3-87a2-90fa8bf85872.jpg',
                 'http://i.imgur.com/cGDUG1B.jpg',
                 'https://f.cloud.github.com/assets/17722/2141926/8143e812-935e-11e3-9188-e48035860036.jpg'
      ).sample
    else
      pong = pong_images.sample
    end

    msg.reply(pong)
  end
end
