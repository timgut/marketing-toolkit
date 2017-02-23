namespace :unicorn do
  desc "restart unicorn server"

  task :restart do
    on roles(:web) do
      execute "/data/sysadm/unicorn_manager #{fetch(:full_application)} #{fetch(:rails_env)} stop"
      execute "/data/sysadm/unicorn_manager #{fetch(:full_application)} #{fetch(:rails_env)} start"
    end
  end

  desc "reload unicorn server"
  task :reload do
    on roles(:web) do
      execute "/data/sysadm/unicorn_manager #{fetch(:full_application)} #{fetch(:rails_env)} reload"
    end
  end

  desc "stop unicorn server"
  task :stop do
    on roles(:web) do
      execute "/data/sysadm/unicorn_manager #{fetch(:full_application)} #{fetch(:rails_env)} stop"
    end
  end

  desc "start unicorn server"
  task :start do
    on roles(:web) do
      execute "/data/sysadm/unicorn_manager #{fetch(:full_application)} #{fetch(:rails_env)} start"
    end
  end

end
