# config/puma.rb
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count
app_dir = File.expand_path('..', __dir__)
bind "unix:///#{app_dir}/tmp/sockets/puma.sock"
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port        ENV.fetch("PORT") { 3000 }
# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }
# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
