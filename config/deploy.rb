set :application,  "wsj-reader"
set :use_sudo,      false
set :deploy_to,     "/var/www/apps/wsj-reader"

set :copy_strategy, :export
set :keep_releases, 5

default_run_options[:pty] = true
set :repository,  "git@github.com:justin/wsj-reader.git"
set :scm, "git"
#set :scm_passphrase, "2p2aia5" #This is your custom users password
#set :user, "justinandrewrich"

ssh_options[:forward_agent] = true

set :branch, "master"

set :deploy_via, :remote_cache

role :app, "justinrich.com"
role :web, "justinrich.com"
role :db, "justinrich.com", :primary => true

  desc "Create database.yml in shared/config"
  task :after_setup do
    
    database_configuration = <<-EOF
production:
  adapter: mysql
  host: localhost
  username: stripes 
  password: XjLNRvE.:sPhWsWR
  database: wsj_production
  
rake:
  adapter: mysql
  host: localhost
  username: stripes 
  password: XjLNRvE.:sPhWsWR
  database: wsj_production
EOF
  run "mkdir -p #{deploy_to}/#{shared_dir}/config"

  put database_configuration,
      "#{deploy_to}/#{shared_dir}/config/database.yml"
        
    sphinx_configuration = <<-EOF
host: localhost
port: 3315
EOF

  put sphinx_configuration,
      "#{deploy_to}/#{shared_dir}/config/sphinx.yml"
end


namespace :deploy do
  desc "Restart"
  task :restart do
    run "cd #{deploy_to}/current; touch tmp/restart.txt"
  end
  
  desc "Start"
  task :start do
    #run "cd #{deploy_to}/current; touch tmp/restart.txt"
  end
end

#Overwrite the default deploy.migrate as it calls: 
#rake RAILS_ENV=production db:migrate
desc "MIGRATE THE DB!"
deploy.task :migrate do
 #run "cd #{release_path}; rake db:automigrate MERB_ENV=production"
end

desc "Link in the production database.yml" 
task :after_update_code do 
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/sphinx.yml #{release_path}/config/sphinx/sphinx.yml"
  
  # run "cd #{release_path}; thor merb:gem:redeploy"
  #run "cd #{release_path}; indexer --all --rotate"
end
