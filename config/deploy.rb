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

set :delayed_job_server_role, :worker
set :delayed_job_args, "-n 2"

after :deploy, "unicorn:restart"
after :deploy, "delayed_job:restart"

before "deploy:starting", "sucker_punch:check_jobs"

namespace :sucker_punch do
  task :check_jobs do
    on roles(:all) do
      if remote_file_exists?("/data/afscme-tk-dev/current/sucker_punch.lock")
        abort("cap aborted!\nsucker_punch.lock exists on remote server!")
      end
    end
  end
end

def remote_file_exists?(path)
  result = execute("if [ -e '#{path}' ]; then echo -n 'true'; fi") do |ch, stream, out|
    out
  end

  result == true
end

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
