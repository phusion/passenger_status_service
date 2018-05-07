server "passenger_status_service@status-service.dev.phusionpassenger.com", :roles => [:app, :web, :db]

set :rvm_ruby_version, '2.3.4'
set :repo_url, 'git://github.com/phusion/passenger_status_service.git'
set :ssh_options, forward_agent: true
set :default_env, {
  'ROOT_URL' => 'https://status-service.phusionpassenger.com',
  'MAILER_SENDER' => 'admin@status-service.phusionpassenger.com'
}
set :passenger_environment_variables, { :path => '/opt/production/passenger-enterprise/bin:$PATH' }
set :passenger_restart_command, 'env PATH=/opt/production/passenger-enterprise/bin:$PATH passenger-config restart-app'
set :passenger_restart_with_sudo, false
