server ENV['OPENREPLY_DEPLOY_SERVER_PRODUCTION'], :app, :web, :db, :primary => true

set :deploy_to, ENV['OPENREPLY_DEPLOY_TO_PRODUCTION']
set :branch, "master"
set :rails_env, "production"

set :rvm_type, ENV['OPENREPLY_DEPLOY_RVM_TYPE_PRODUCTION'].to_sym # Default rvm_type is :user

set :user, ENV['OPENREPLY_DEPLOY_USER_PRODUCTION']
set :group, ENV['OPENREPLY_DEPLOY_GROUP_PRODUCTION']
set :rvm_path, ENV['OPENREPLY_DEPLOY_RVM_PATH_PRODUCTION']

namespace :deploy do
  desc "Tell Puma to do a hot restart."
  task :restart do
    run "[ ! -f #{fetch(:deploy_to)}/shared/pids/thin.pid ] || /bin/kill `cat #{fetch(:deploy_to)}/shared/pids/thin.pid`"
    deploy.start
  end

  desc "Tell Puma to start."
  task :start do
    run "cd #{fetch(:deploy_to)}/current && bundle exec thin -p 8000 -P #{fetch(:deploy_to)}/current/tmp/pids/thin.pid -l #{fetch(:deploy_to)}/current/log/thin.log -e production -d start"
  end
end


