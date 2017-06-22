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
      last_release = capture(:ls, "-xt", releases_path).split("\t").first
      release_path = releases_path.join(last_release)
      lock_file    = "#{release_path}/sucker_punch.lock"
      file_exists  = capture("if [ -e '#{lock_file}' ]; then echo -n 'true'; fi") == "true"

      if file_exists
        abort("cap aborted!\nsucker_punch.lock exists on remote server!")
      end
    end
  end
end

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
