require "bundler/capistrano"
require "capistrano-nc"

server "50.116.63.166", :web, :app, :db, primary: true

#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"

set :application, "bento"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:olimart/bento.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy:setup", "init:set_permissions"
after "deploy:setup", "init:database_yaml"
after "deploy:setup", "init:production_file"
after "deploy:setup", "init:config_file"
after "deploy:setup", "init:setup_config"
after "deploy:setup", "init:create_upload_directory"

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :init do
  
  desc "Set proper permissions for deployment user"
  task :set_permissions do
    sudo "mkdir -p #{shared_path}/config"
    sudo "chown -R #{user}:admin #{deploy_to}"
  end
  
  desc "Create database yaml"
  task :database_yaml do
    set :db_name, Capistrano::CLI.ui.ask("database name: ")
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_password, Capistrano::CLI.password_prompt("database password: ")
    set :db_host, Capistrano::CLI.password_prompt("database host: ")
    db_config = ERB.new <<EOF
production:
  adapter: postgresql
  encoding: unicode
  username: #{db_user}
  password: #{db_password}
  database: #{db_name}
  host: #{db_host}
  pool: 5
EOF
    
    put db_config.result, "#{shared_path}/config/database.yml"
  end
  
  desc "Create production.rb"
  task :production_file do
    template = ERB.new(File.read('config/environments/production.rb'))
    # mail server
    mail_server_address = Capistrano::CLI.ui.ask('What is mail server address ("smtp.domain.com")?: ')
    mail_server_post = Capistrano::CLI.ui.ask('What is mail server port (587)?: ')
    mail_server_username = Capistrano::CLI.ui.ask('What is mail server username?: ')
    mail_server_password = Capistrano::CLI.ui.ask('What is mail server password?: ')
    
    run "mkdir -p #{shared_path}/config"
    put template.result(binding), "#{shared_path}/config/production.rb"
  end
  
  desc "Create config. file"
  task :config_file do
  	put File.read("config/application.sample.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config file in #{shared_path}."
  end

  desc "Create server config symlinks"
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end

  desc "Create upload directory for pictures"
  task :create_upload_directory do
    run "mkdir -p #{shared_path}/upload" 
  end
end

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :symlink_config, roles: :app do
    puts "Run symlink"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/production.rb"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"

    # LINK UPLOADS DIR
    puts "Link upload directory"
    run "rm -rf #{release_path}/public/upload"
    run "ln -s  #{shared_path}/upload #{release_path}/public/upload"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"

end


###### DB TASKS #######
namespace :db do
  desc "Migrate database"
  task :migrate, roles: :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:migrate --trace"
  end
  
  desc "Seed database"
  task :seed, roles: :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:seed --trace"
  end
  
  desc "Drop & Migrate database"
  task :reset, roles: :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:drop db:migrate --trace"
  end
end