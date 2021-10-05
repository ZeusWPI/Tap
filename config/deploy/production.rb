server 'tap.zeus.gent', user: 'tap', roles: %w{web app db}, ssh_options: {
  forward_agent: true,
  auth_methods: ['publickey'],
  port: 2222
}

set :rails_env, 'production'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip

# NVM config
set :default_env, {
  path: "/home/tap/.nvm/versions/node/v14.18.0/bin:$PATH"
}
