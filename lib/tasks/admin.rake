namespace :admin do
  desc "Create an admin user"
  task :create => :environment do
    require 'highline'
    h = HighLine.new
    begin
      email = h.ask("Email: ")
      password = h.ask("Password (min 8 characters): ") { |q| q.echo = false }
      password_confirmation = h.ask("Confirm password: ") { |q| q.echo = false }
    rescue Interrupt
      exit 1
    end

    user = User.new
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation
    user.admin = true
    if user.save
      puts "Admin user created."
    else
      puts "Cannot create admin user:"
      user.errors.full_messages.each do |message|
        puts " * #{message}"
      end
    end
  end
end
