namespace :deploy do

  desc "restart rails application"
  task :restart do
    unicorn.restart
  end

  desc "reload rails application"
  task :reload do
    unicorn.reload
  end

  desc "stop rails application"
  task :stop do
    unicorn.stop
  end

  desc "start rails application"
  task :start do
    unicorn.start
  end
end


namespace :unicorn do
  desc "restart unicorn server"
  task :restart do
    stop
    start
  end

  desc "reload unicorn server"
  task :reload do
    run "/data/sysadm/unicorn_manager #{full_application} #{rails_env} reload"
  end

  desc "stop unicorn server"
  task :stop do
    run "/data/sysadm/unicorn_manager #{full_application} #{rails_env} stop"
  end

  desc "start unicorn server"
  task :start do
    run "/data/sysadm/unicorn_manager #{full_application} #{rails_env} start"
  end
end
