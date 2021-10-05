# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/rbenv'
#require 'capistrano/rvm'

# NVM (Node Version Manager) support
require 'capistrano/nvm'
set :nvm_type, :user
set :nvm_node, 'v14.18.0'
set :nvm_map_bins, %w{node npm yarn}
set :nvm_custom_path, '/home/tap/.nvm/'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
