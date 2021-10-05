server 'tap.zeus.gent', user: 'tap', roles: %w{web app db}, ssh_options: {
  forward_agent: true,
  auth_methods: ['publickey'],
  port: 2222
}

set :rails_env, 'production'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip

# NVM config
set :nvm_type, :user
set :nvm_node, 'v14.18.0'
set :nvm_map_bins, %w{node npm yarn}
