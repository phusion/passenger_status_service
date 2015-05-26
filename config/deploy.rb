set :application, 'passenger_status_service'
set :pty, true
set :bundle_flags, '--deployment'
set :bundle_jobs, 4
set :rails_env, 'production'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Restart Passenger
      execute :touch, 'tmp/restart.txt'
    end
  end
end
