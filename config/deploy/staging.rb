server ENV['OPENREPLY_DEPLOY_SERVER_STAGING'], :app, :web, :db, :primary => true

set :deploy_to, ENV['OPENREPLY_DEPLOY_TO_STAGING']
set :branch, "develop"
set :rails_env, "staging"

set :rvm_type, ENV['OPENREPLY_DEPLOY_RVM_TYPE_STAGING'].to_sym # Default rvm_type is :user

set :user, ENV['OPENREPLY_DEPLOY_USER_STAGING']
set :group, ENV['OPENREPLY_DEPLOY_GROUP_STAGING']

namespace :deploy do
  desc "Tell Puma to do a hot restart."
  task :restart do
    run "[ ! -f #{fetch(:deploy_to)}/shared/pids/thin.pid ] || /bin/kill `cat #{fetch(:deploy_to)}/shared/pids/thin.pid`"
    deploy.start
  end

  desc "Tell Puma to start."
  task :start do
    run "cd #{fetch(:deploy_to)}/current && bundle exec thin -p 8000 -P #{fetch(:deploy_to)}/current/tmp/pids/thin.pid -l #{fetch(:deploy_to)}/current/log/thin.log -e staging -d start"
  end
end
