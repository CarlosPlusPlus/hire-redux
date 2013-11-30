require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano'

# Load YAML data for deployment setup.
settings = YAML.load_file('config/application.yml')

set :application, settings['APP_NAME']
set :repository,  settings['APP_REPO']

set :user, 'acdc'
set :deploy_to, "/home/#{ user }/#{ application }"
set :use_sudo, false
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

default_run_options[:pty] = true

role :web, settings['APP_SERVER_IP']  # Your HTTP server, Apache/etc
role :app, settings['APP_SERVER_IP']  # This may be the same as your `Web` server
role :db,  settings['APP_SERVER_IP']  # This may be the same as your `Web` server

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :setup_server do

    # Copy all styling elements from database.
    run "cp #{current_release}/vendor/assets/perfectum_dashboard_1_0_5/css/* #{current_release}/public"
    run "cp #{current_release}/vendor/assets/perfectum_dashboard_1_0_5/css/* #{current_release}/public/assets"
    run "cp -rf #{current_release}/vendor/assets/perfectum_dashboard_1_0_5/img/* #{current_release}/public/img"
    run "cp -rf #{current_release}/vendor/assets/perfectum_dashboard_1_0_5/img/* #{current_release}/public/assets/img"  
  end

  task :symlink_config, :roles => :app do 
    run "ln -nfs #{shared_path}/application.yml #{current_release}/config/application.yml"
    run "ln -nfs #{shared_path}/database.yml #{current_release}/config/database.yml"
    run "ln -nfs #{shared_path}/production.sqlite3 #{current_release}/db/production.sqlite3"
  end

end 

# Load assets here and create symlinks.
before 'bundle:install', 'deploy:symlink_config'
after 'deploy:update_code','deploy:setup_server'