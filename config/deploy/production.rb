set :stage, :production

set :rails_env,   "production"
set :deploy_to,   "/data/#{fetch(:application)}-prod"
set :deploy_user, "app-#{fetch(:application)}"

server "chi-rails1", user: 'app-afscme-tk', roles: %w(web app db)