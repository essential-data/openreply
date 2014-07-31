server ENV['OPENREPLY_DEPLOY_SERVER_PRODUCTION'], :app, :web, :db, :primary => true

set :deploy_to, ENV['OPENREPLY_DEPLOY_TO_PRODUCTION']
set :branch, "master"
set :rails_env, "production"

set :rvm_type, ENV['OPENREPLY_DEPLOY_RVM_TYPE_PRODUCTION'].to_sym # Default rvm_type is :user

set :user, ENV['OPENREPLY_DEPLOY_USER_PRODUCTION']
set :group, ENV['OPENREPLY_DEPLOY_GROUP_PRODUCTION']
