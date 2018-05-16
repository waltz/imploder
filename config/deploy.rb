lock '3.10.1'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :deploy_user, 'deploy'
set :application, 'imploder'
set :repo_url, 'https://github.com/waltz/imploder.git'
set :deploy_to, '/var/www/app'
set :bundle_flags, '--deployment'
set :bundle_env_variables, { nokogiri_use_system_libraries: 1, with_pg_lib: '/usr/lib' }
set :ssh_options, {
  forward_agent: true,
  keys: [File.expand_path(File.dirname(__FILE__) + '/imploder-staging.key')]
}
set :rails_env, 'production'
server ENV.fetch('DEPLOY_HOST'), user: 'deploy', roles: %w{app db web}
