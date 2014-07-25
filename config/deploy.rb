# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, "support-#{fetch(:stage)}"

set :repo_url, 'git@github.com:catapult-elearning/ostendo-api.git'

set :linked_files, %w{config/database.yml config/secrets.yml config/puma.rb}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets tmp/views vendor/bundle public/cache public/assets}

set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.socket"

set :use_sudo, false

set :ssh_options, {
   keys: %w(~/.ssh/id_rsa),
   forward_agent: true
}

set(:config_files, %w(
  database.example.yml
  secrets.example.yml
))

set :default_env, { path: "/Users/deploy/.rvm/gems/ruby-2.1.2/bin:/Users/deploy/.rvm/gems/ruby-2.1.2@global/bin:/Users/deploy/.rvm/rubies/ruby-2.1.2/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/Users/deploy/.rvm/bin" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  
  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

end