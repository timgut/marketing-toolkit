set :stage,       :aws_edge
set :rails_env,   "staging"
set :deploy_to,   "/data/afscme-tk-edge"
set :deploy_user, "app-afscme-tk-edge"
set :branch,      "edge"
set :default_env, { 'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }
set :full_application, "afscme-tk-edge"

SSHKit.config.command_map[:bundle] = "bundle"

server "chi-dev", user: "app-afscme-tk-edge", roles: %w(web app db)
