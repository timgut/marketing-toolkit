set :stage,       :aws_edge
set :rails_env,   "staging"
set :deploy_to,   "/data/afscme-tk-edge"
set :deploy_user, "app-afscme-tk-edge"
set :branch,      "edge"
set :full_application, "afscme-tk-edge"
# set :default_env, { 'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }

server "chi-dev", user: "app-afscme-tk-edge", roles: %w(web app db)
