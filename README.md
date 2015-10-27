# About the Passenger Status Service

Welcome to the Passenger Status Service. This is a service provided by [Phusion](http://www.phusion.nl/) for the [Passenger application server](https://www.phusionpassenger.com/). This service makes Passenger status reports (the `passenger-status` tool) work on Heroku.

## The problem with Passenger status reports on Heroku

Passenger status reports are gathered by running a the `passenger-status` tool, which queries a Passenger instance running on the same machine. However, Heroku does not provide SSH access to the servers on which your app is running, so it is not possible to run the `passenger-status` tool to obtain a status report from Passenger. The `heroku console` command spawns a one-off dyno instead of granting you access to the running servers, so that doesn't work either.

![Passenger Status Service overview](https://raw.githubusercontent.com/phusion/passenger_status_service/master/app/assets/images/service_overview.png)

The Passenger Status Service solves this problem. It works as follows:

 * You add a reporting command to your Procfile. This reporting command gathers a status report from the local Heroku server and posts it to the Passenger Status Service.
 * You view the status reports through the Passenger Status Service.

## Hosted service vs self-hosting

The Passenger Status Service is an open source Rails app. Phusion provides a hosted version at [https://status-service.phusionpassenger.com](https://status-service.phusionpassenger.com). To get started, [sign up for an account](https://status-service.phusionpassenger.com/users/sign_up).

The hosted version is easy to use, but the disadvantage is that we will have access to your data. [Wondering what data is sent?](https://status-service.phusionpassenger.com/faq#what_data). You can also choose to self-host this service. That way, you are in control of all your data.

## Self-hosting guide

This app requires PostgreSQL.

 1. Install Ruby 2.2.
 2. [Install Nginx + Passenger](https://wwww.phusionpassenger.com/).
 3. Create a user `passenger_status_service`:

        $ sudo adduser passenger_status_service
        $ sudo passwd passenger_status_service

 4. Clone this repository to '/var/www/passenger_status_service':

        $ sudo mkdir /var/www/passenger_status_service
        $ sudo chown passenger_status_service: /var/www/passenger_status_service
        $ sudo -u passenger_status_service -H git clone git://github.com/phusion/passenger_status_service.git /var/www/passenger_status_service
        $ cd /var/www/passenger_status_service

 5. Open a shell as `passenger_status_service`. If you are using RVM:

        $ rvmsudo -u passenger_status_service -H bash
        $ export RAILS_ENV=production

    If you are not using RVM:

        $ sudo -u passenger_status_service -H bash
        $ export RAILS_ENV=production

 6. Create a database, edit database configuration:

        $ cp config/database.yml.example config/database.yml
        $ editor config/database.yml

 7. Install the gem bundle:

        $ bundle install --without development test --production

 8. Run database migrations, generate assets:

        $ bundle exec rake db:migrate assets:precompile

 9. Create an admin user:

        $ bundle exec rake admin:create
        Email: ...
        Password: ...
        Confirm password: ...
        Admin user created.

 10. Generate a secret key:

        $ bundle rake secret

     Take note of the output. You need it in the next step.

 11. Add Nginx virtual host. Be sure to substitute the `passenger_env_var` values with appropriate values.

        server {
            listen 443;
            server_name www.yourhost.com;
            ssl_certificate ...;
            ssl_certificate_key ...;
            ssl on;
            root /var/www/passenger_status_service/public;
            passenger_enabled on;

            # Fill in an appropriate value for email 'From' fields.
            passenger_env_var MAILER_SENDER yourapp@yourdomain.com;
            # Fill in the root URL of the app.
            passenger_env_var ROOT_URL https://www.yourhost.com;
            # Fill in value of secret key you generated in step 10.
            passenger_env_var SECRET_KEY_BASE ...;
        }
