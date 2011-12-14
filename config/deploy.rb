require "bundler/capistrano"
set :application, "cone"
set :repository,  "git://github.com/timmyc/freshies.git"

set :scm, :git

role :web, "freshies"                          # Your HTTP server, Apache/etc
role :app, "freshies"                          # This may be the same as your `Web` server
role :db,  "freshies", :primary => true # This is where Rails migrations will run
set :deploy_to, '/home/timmy/conepatrol.com'

desc "Symlink db config and public assets"    
task :symlink_assets, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
  run "ln -nfs #{shared_path}/config/environments/production.rb #{release_path}/config/environments/"
  run "ln -nfs #{shared_path}/tmp/ #{release_path}/tmp/"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
after "deploy", "symlink_assets"
