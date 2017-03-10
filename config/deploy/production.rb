set :stage, :production

set :full_application, "#{fetch(:application)}-prod"

set :rails_env,   "production"
set :deploy_to,   "/data/#{fetch(:application)}-prod"
set :deploy_user, "app-#{fetch(:application)}"


set :branch, "master"

server "chi-rails1", user: 'app-afscme-tk', roles: %w(web app db)