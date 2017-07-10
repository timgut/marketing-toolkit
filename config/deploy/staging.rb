set :stage, :staging

set :full_application, "#{fetch(:application)}-dev"

set :rails_env,   "staging"
set :deploy_to,   "/data/#{fetch(:application)}-dev"
set :deploy_user, "app-#{fetch(:application)}"

set :branch, "dev" ## this is for the 1732-related changes; see that ticket in redmine

server "chi-dev", user: 'app-afscme-tk', roles: %w(web app db)
