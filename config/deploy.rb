# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "afscme-tk"
set :repo_url, "git@github.com:trilogyinteractive/afscme-toolkit.git"
set :deploy_via,  :remote_cache
set :use_sudo,    false
set :deploy_user, "foo"

set :branch, "dev"

set :keep_releases, 3
set :keep_assets, 8
set :assets_roles, [:web, :app]

set :linked_files, %w{config/database.yml config/unicorn.conf.rb config/secrets.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')

set :migration_role, :db

after :deploy, "unicorn:restart"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
