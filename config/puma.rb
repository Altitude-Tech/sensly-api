##
# Puma config script
##
workers 2
threads 1, 6

app_dir = File.expand_path('../..', __FILE__)
shared_dir = "#{app_dir}/shared"

environment = ENV['RAILS_ENV'] || 'development'

# socket location
# use /tmp so it works on vagrant too
# <http://stackoverflow.com/a/16404342>
bind 'unix:///tmp/puma.sock'

# logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app__dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require 'active_record'

  # rubocop:disable Lint/HandleExceptions
  begin
    ActiveRecord::Base.connection.disconnect!
  rescue ActiveRecord::ConnectionNotEstablished
  end
  # rubocop:enable Lint/HandleExceptions

  db_config = YAML.load_file("#{app_dir}/config/database.yml")[environment]
  ActiveRecord::Base.establish_connection(db_config)
end
