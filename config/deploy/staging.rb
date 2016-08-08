server 'zeus.ugent.be', user: 'tap-beta', roles: %w{web app db}, ssh_options: {
  forward_agent: true,
  auth_methods: ['publickey'],
  port: 2222
}

set :rails_env, 'staging'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
set :application, "tap-beta"

set :branch, '2.0'
set :deploy_to, '/home/tap-beta/production'
