set :stage, :staging

set :full_application, "#{fetch(:application)}-dev"

set :rails_env,   "staging"
set :deploy_to,   "/data/#{fetch(:application)}-dev"
set :deploy_user, "app-#{fetch(:application)}"

set :branch, "dev"

server "chi-dev", user: 'app-afscme-tk', roles: %w(web app db)
