set :application, "pixassistant"
set :domain, 'miku.manic.tw'
set :repository,  "git://github.com/manic/#{application}.git"
set :deploy_to, "/webapps/pixassistant.miku.manic.tw/weblib/"

role :app, domain
role :web, domain
role :db, domain, :primary => true

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

set :user, 'railsapp'
set :group, 'www-data'

default_environment["RAILS_ENV"] = "production"

namespace :deploy do
  desc "restart"
  task :restart do
    run "touch #{release_path}/tmp/restart.txt"
  end
end

desc "link shared file"
after("deploy:update_code") do
  db_config = "/webapps/dbconfig/pixassistant.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

