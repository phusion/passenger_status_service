server "passenger_status_service@shell.phusion.nl", :roles => [:app, :web, :db]

set :rvm_ruby_version, '2.2.1'
set :repo_url, 'git://github.com/phusion/passenger_status_service.git'
set :ssh_options, forward_agent: true
set :default_env, {
  'ROOT_URL' => 'https://status-service.phusionpassenger.com',
  'MAILER_SENDER' => 'admin@phusionpassenger.com'
}
set :passenger_environment_variables, { :path => '/opt/production/passenger-enterprise/bin:$PATH' }
set :passenger_restart_command, '/opt/production/passenger-enterprise/bin/passenger-config restart-app'
set :passenger_restart_with_sudo, true
