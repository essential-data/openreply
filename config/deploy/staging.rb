server ENV['OPENREPLY_DEPLOY_SERVER_STAGING'], :app, :web, :db, :primary => true

set :deploy_to, ENV['OPENREPLY_DEPLOY_TO_STAGING']
set :branch, "feature/refactoring"
set :rails_env, "staging"

set :rvm_type, ENV['OPENREPLY_DEPLOY_RVM_TYPE_STAGING'].to_sym # Default rvm_type is :user

set :user, ENV['OPENREPLY_DEPLOY_USER_STAGING']
set :group, ENV['OPENREPLY_DEPLOY_GROUP_STAGING']
