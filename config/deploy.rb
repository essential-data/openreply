require "bundler/capistrano"
require "capistrano/ext/multistage"
require "rvm/capistrano"
require "dotenv"
require "dotenv/deployment/capistrano"
Dotenv.load '.env'

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

set :stages, %w(production staging)
set :default_stage, "staging"

set :application, "openreply"

set :scm, :git
set :repository, ENV['OPENREPLY_DEPLOY_REPOSITORY']
set :local_repository, ENV['OPENREPLY_DEPLOY_REPOSITORY']

set :use_sudo, false
set :deploy_via, :copy
set :copy_exclude, [".git/*", ".gitignore", ".DS_Store"]

set :normalize_asset_timestamps, false

namespace :deploy do
  desc "Tell Puma to do a hot restart."
  task :restart do
    run "/bin/kill `cat #{fetch(:deploy_to)}/shared/pids/thin.pid`"
    deploy.start
  end

  desc "Tell Puma to start."
  task :start do
    run "cd #{fetch(:deploy_to)}/current && bundle exec thin -p 8000 -P #{fetch(:deploy_to)}/current/tmp/pids/thin.pid -l #{fetch(:deploy_to)}/current/log/thin.log -e production -d start"
  end

end
