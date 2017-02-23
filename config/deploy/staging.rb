set :stage, :staging

set :rails_env,   "staging"
set :deploy_to,   "/data/#{fetch(:application)}-dev"
set :deploy_user, "app-#{fetch(:application)}"

server "chi-dev", user: 'app-afscme-tk', roles: %w(web app db)
