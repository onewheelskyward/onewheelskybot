require 'json'
require 'httparty'
require 'nokogiri'
require_relative '../helpers'

class Reddit
  include Cinch::Plugin

  match /(reddit.com\/)$/i, method: :execute

  set :help, <<-EOF
Moon phase and civil twilight information.
  EOF
x = <<END
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                        <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
  <head>
  <link rel="apple-touch-icon" href="/static/compact/reddit-apple-mobile-device.png"/>
  <link rel="apple-touch-startup-image" href="/static/compact/reddit_startimg.png" />
  <link rel="canonical" href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/" />
  <link rel="shorturl" href="http://redd.it/277rk9" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black" />
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
  <title>[559] * Accept and appropriate a grant in the amount of $1,147,270 from the Oregon Department of Transportation for the Springwater Trail Gap: SE Umatilla to SE 13th Ave (Ordinance) : pdxcouncilagenda</title>
		<meta name="title" content=" [559] * Accept and appropriate a grant in the amount of $1,147,270 from the Oregon Department of Transportation for the Springwater Trail Gap: SE Umatilla to SE 13th Ave (Ordinance) : pdxcouncilagenda " />
  <meta name="description" content="Session: 2014-06-04 09:30:00 -0700 PDF: http://www.portlandonline.com/auditor/index.cfm?c=50265&amp;a=492258" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="stylesheet" href="http://www.redditstatic.com/compact.NkZqjDlznjA.css" type="text/css" media="screen" />
  <!--[if gte IE 9]><!--><script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script><script type="text/javascript" src="http://www.redditstatic.com/reddit-init.en.vS1qHBiY5OQ.js"></script><!--<![endif]--><!--[if lt IE 9]><script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script><script type="text/javascript" src="http://www.redditstatic.com/reddit-init.en.vS1qHBiY5OQ.js"></script><![endif]--><script type="text/javascript" id="config">r.setup({"ajax_domain": "www.reddit.com", "server_time": 1401815914.0, "post_site": "pdxcouncilagenda", "clicktracker_url": "//pixel.redditmedia.com/click", "logged": false, "cur_domain": "reddit.com", "gold": false, "is_fake": false, "renderstyle": "compact", "over_18": false, "vote_hash": "M8iA6M+YWf8H+lKN1lNQvciHT/UmP94mzvyUcRcdgkA3zmTB+dCKHIvxBbebP3xRfGXvUj0auBDgK7UOBHEw54cf38D7pVnWs7Rxuz1CxE/aJldNJvVpXUaHTH7dHXoKxTHm/kXlriNWeWGwyra4yZIc/5eufKDM+ut6pt1+tBZdhZqxuSymu7s=", "adtracker_url": "//pixel.redditmedia.com/pixel/of_doom.png", "uitracker_url": "//pixel.redditmedia.com/pixel/of_discovery.png", "fetch_trackers_url": "//tracker.redditmedia.com/fetch-trackers", "modhash": false, "store_visits": false, "new_window": false, "send_logs": true, "pageInfo": {"actionName": "front.GET_comments", "verification": "388228f7328f4f4378f87784f3f47137498db25f"}, "https_endpoint": "https://ssl.reddit.com", "extension": "compact", "static_root": "http://www.redditstatic.com", "status_msg": {"fetching": "fetching title...", "loading": "loading...", "submitting": "submitting..."}, "debug": false, "has_subscribed": false})</script><script type="text/javascript">var user_type = 'guest'; var _gaq = _gaq || []; _gaq.push( ['_setAccount', 'UA-12131688-1'], ['_setDomainName', 'reddit.com'], ['_setCustomVar', 1, 'site', 'pdxcouncilagenda', 3], ['_setCustomVar', 2, 'srpath', 'pdxcouncilagenda-compact', 3], ['_setCustomVar', 3, 'usertype', user_type, 2], ['_setCustomVar', 4, 'uitype', 'mobile', 3], ['_trackPageview'] ); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>
	</head>
	<body class="post-under-24h-old post-under-6h-old single-page comments-page" >
		<div id="preload">
			<div class="commentcount">
				<div class="comments"></div>
				<div class="comments preloaded"></div>
			</div>
		</div>
		<div id="topbar">
			<div class="left"><a href="http://www.reddit.com/.compact" id="header-img-a" ><img id='header-img' src="http://e.thumbs.redditmedia.com/XhwuHdBJXX16v8ZR.png" width='330' height='104' alt="pdxcouncilagenda"/></a></div>
			<h1><span class="hover pagename redditname"><a href="http://www.reddit.com/r/pdxcouncilagenda/.compact" >pdxcouncilagenda</a></span></h1>
			<div class="right"><a class="topbar-options" href="#" id="topmenu_toggle"></a></div>
      <div id="top_menu">
          <div class="menuitem"><a href="http://www.reddit.com/login.compact" >login</a></div>
      <div class="menuitem bottm-bar"><a href="http://www.reddit.com/register.compact" >register</a></div>
      <div class="menuitem"><a href="http://www.reddit.com/subreddits/.compact" >subreddits</a></div>
      <div class="menuitem"><a href="http://www.reddit.com/r/pdxcouncilagenda/search.compact" >search</a></div>
      </div>
		</div>
      <div class="subtoolbar">
      <ul class="tabmenu " >
      <li class='selected'><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact" >comments</a></li>
      <li ><a href="http://www.reddit.com/r/pdxcouncilagenda/related/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact" >related</a></li>
      </ul>
		</div>
      <div class="content">
      <div id="siteTable" class="sitetable linklisting">
      <div class="thing link id-t3_277rk9">
      <span class="rank">1</span>
					<div class="midcol unvoted">
						<div class="arrow up login-required" onclick="$(this).vote(r.config.vote_hash, null, event)" role="button" aria-label="upvote" tabindex="0" ></div>
      <div class="arrow down login-required" onclick="$(this).vote(r.config.vote_hash, null, event)" role="button" aria-label="downvote" tabindex="0" ></div>
					</div>
      <div class="entry unvoted">
      <p class="title"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact">[559] * Accept and appropriate a grant in the amount of $1,147,270 from the Oregon Department of Transportation for the Springwater Trail Gap: SE Umatilla to SE 13th Ave (Ordinance)</a><span class="domain">(self)</span></p>
						<div class="tagline"><span><span class="score dislikes">0 points</span><span class="score unvoted">1 point</span><span class="score likes">2 points</span>&#32;submitted&#32;<time title="Tue Jun 3 17:02:45 2014 UTC" datetime="2014-06-03T17:02:45+00:00" class="live-timestamp">15 minutes ago</time></span>&#32;<span>by&#32;<a href="http://www.reddit.com/user/pdxapibot.compact" class="author may-blank id-t2_gq12z" >pdxapibot</a><span class="userattrs"></span></span></div>
      </div>
					<a href="javascript:void(0)" class="options_link"></a>
      <div class="expando" >
      <form action="#" class="usertext" onsubmit="return post_form(this, 'editusertext')" id="form-t3_277rk90a2">
      <input type="hidden" name="thing_id" value="t3_277rk9"/>
      <div class="usertext-body">
      <div class="md">
      <p>Session: 2014-06-04 09:30:00 -0700</p>
									<p>PDF: <a href="http://www.portlandonline.com/auditor/index.cfm?c=50265&amp;a=492258" rel="nofollow">http://www.portlandonline.com/auditor/index.cfm?c=50265&amp;a=492258</a></p>
								</div>
							</div>
						</form>
					</div>
					<div class="clear options_expando hidden">
						<a href="mailto:?subject=%5Breddit%5D%20I%20wanted%20to%20share%20this%20link%20with%20you&amp;body=A%20reddit%20user%20shared%20a%20link%20with%20you%20from%20reddit%20%28http%3A//www.reddit.com/%29%3A%0A%0Ahttp%3A//www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/%0A%0A%22%5B559%5D%20%2A%20Accept%20and%20appropriate%20a%20grant%20in%20the%20amount%20of%20%241%2C147%2C270%20from%20the%20Oregon%20Department%20of%20Transportation%20for%20the%20Springwater%20Trail%20Gap%3A%20SE%20Umatilla%20to%20SE%2013th%20Ave%20%28Ordinance%29%22%0A%0Athere%27s%20also%20a%20discussion%20going%20on%20here%3A%0A%0Ahttp%3A//www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/%0A" >
							<div class="email-icon"></div>
							Share
						</a>
						<a href="javascript:void(0)" onclick="return change_state(this, 'report', hide_thing)" >
							<div class="report-icon"></div>
							Report
						</a>
					</div>
				</div>
			</div>
			<div class='commentarea'>
				<div class="panestack-title"><span class="title">no comments (yet)</span></div>
				<div class="menuarea subtoolbar">
					<ul class="lightdrop hover" >
						<li class='selected'>
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="confidence"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=confidence" onclick="$(this).parent().submit(); return false;" >best</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="top"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=top" onclick="$(this).parent().submit(); return false;" >top</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="new"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=new" onclick="$(this).parent().submit(); return false;" >new</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="hot"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=hot" onclick="$(this).parent().submit(); return false;" >hot</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="controversial"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=controversial" onclick="$(this).parent().submit(); return false;" >controversial</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="old"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=old" onclick="$(this).parent().submit(); return false;" >old</a></form>
						</li>
						<li >
							<form method="POST" action="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact"><input type="hidden" name="sort" value="random"><a href="http://www.reddit.com/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact?sort=random" class="hidden" onclick="$(this).parent().submit(); return false;" >random</a></form>
						</li>
					</ul>
				</div>
				<div id="siteTable_t3_277rk9" class="sitetable nestedlisting"></div>
				<p id="noresults" class="error">there doesn't seem to be anything here</p>
			</div>
		</div>
		<div class="login-popup cover-overlay" style="display: none">
			<div class="cover" onclick="return hidecover(this)"></div>
			<div class="popup">
				<form id="login_login" method="post" action="https://ssl.reddit.com/r/pdxcouncilagenda/post/login.compact" class="user-form login-form">
					<input type="hidden" name="op" value="login" /><input type="hidden" name="dest" value="/r/pdxcouncilagenda/comments/277rk9/559_accept_and_appropriate_a_grant_in_the_amount/.compact" />
					<div>
						<ul>
							<li class="name-entry"><label for="user_login">username:</label><input value="" name="user" id="user_login" type="text" maxlength="20" tabindex="2" autofocus /></li>
							<li><label for="passwd_login">password:</label><input id="passwd_login" name="passwd" type="password" tabindex="2"/><span class="error WRONG_PASSWORD field-passwd" style="display:none"></span></li>
							<li><input type="checkbox" name="rem" id="rem_login" tabindex="2" /><label for="rem_login" class="remember">remember me</label></li>
							<li><a class="recover-password" href="/password">recover password</a></li>
						</ul>
						<p class="submit"><button type="submit" class="button" tabindex="2">login</button><span class="throbber"></span><span class="status"></span></p>
					</div>
				</form>
			</div>
		</div>
		<img alt="" src="//pixel.redditmedia.com/pixel/of_destiny.png?v=48WgTzeYP4ghYa0eFah9KXyiclWWwN7u0eDMPK518oHnTLfm986W7opNItTMolaPotHe3hNcBqQ%3D"/><script type="text/javascript" src="http://www.redditstatic.com/mobile.en.KwzRJVdtiGM.js"></script>
	</body>
</html>
END
end
