# config valid only for Capistrano 3.1
# lock '3.1.0'

set :application, 'Tap'
set :repo_url, 'https://github.com/ZeusWPI/Tap.git'

set :branch, 'master'
set :deploy_to, '/home/tap/production'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, []

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# capistrano-docker specific
set :docker_command, "podman"
set :docker_copy_data, %w{.env config/database.yml}

set :docker_compose, true
set :docker_compose_path, "docker-compose.prod.yml"
set :docker_compose_command, "podman-compose"
set :docker_compose_project_name, "tap"
