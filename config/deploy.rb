require 'byebug'
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

set :linked_files, %w{config/database.yml config/unicorn.conf.rb config/secrets.yml config/mailer.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')

set :migration_role, :db

task :check_jobs do
  on roles(:all) do
    last_release = capture(:ls, "-xt", releases_path).split("\t").first
    release_path = releases_path.join(last_release).to_s
    lock_file    = "#{release_path}/sucker_punch.lock"
    file_exists  = capture("if [ -e '#{lock_file}' ]; then echo -n 'true'; fi") == "true"

    if file_exists
      abort("cap aborted!\nsucker_punch.lock exists on remote server!")
    else
      puts "sucker_punch.lock does not exist on remote server. Continuing...\n"
    end
  end
end

before :deploy, :check_jobs

after :deploy, "unicorn:restart"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
