set :stage, :production

set :full_application, "#{fetch(:application)}-prod-rev"

set :rails_env,   "production"
set :deploy_to,   "/data/#{fetch(:application)}-prod-rev"
set :deploy_user, "app-#{fetch(:application)}-rev"

set :branch, "edge"

server "chi-afscme", user: 'app-afscme-tk-rev', roles: %w(web app db)