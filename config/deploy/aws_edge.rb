set :stage,       :aws_edge
set :rails_env,   "production"
set :deploy_to,   "/data/afscme-tk-edge"
set :deploy_user, "app-afscme-tk-edge"
set :branch,      "edge"

SSHKit.config.command_map[:bundle] = "bin/bundle"

server "chi-dev", user: 'app-afscme-tk-edge', roles: %w(web app db)
