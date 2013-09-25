set :application, "onewheelskybot"
set :repository,  "git@github.com:onewheelskyward/onewheelskybot"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "pucksteak"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
set :use_sudo,		false
set :normalize_asset_timestamps, false

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "ps auxww | grep 'ruby bot.rb' | grep -v grep | awk '{print $2}' | xargs kill "
    #run "cd /u/apps/onewheelskybot/current ; ~/.rbenv/shims/ruby bot.rb"
  end
  task :create_config_symlink do
    run "ln -s /u/apps/onewheelskybot/shared/config.yml /u/apps/onewheelskybot/current/config.yml"
  end
end
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
after "deploy:create_symlink", "deploy:create_config_symlink"
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
