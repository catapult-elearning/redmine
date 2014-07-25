set :application, 'support-staging'

set :stage, :staging

set :branch, '2.5-stable'

server 'support-staging.catapult-elearning.com', user: 'deploy', roles: %w{web app db}

set :rails_env, "staging"

set :puma_env, fetch(:rack_env, fetch(:rails_env, 'staging'))
