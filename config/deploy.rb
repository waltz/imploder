lock '3.6.1'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :deploy_user, 'deploy'
set :application, 'exportgifsound.com'
set :repo_url, 'https://github.com/waltz/exportgifsound.com.git'
set :deploy_to, '/var/www/app'
set :bundle_flags, '--deployment'
set :bundle_env_variables, { nokogiri_use_system_libraries: 1, with_pg_lib: '/usr/lib' }


if File.exist?(Rails.root.join('config', 'imploder-staging.key'))
  set :ssh_options, keys: [Rails.root.join('config', 'imploder-staging.key')]
  puts "Using imploder key..."
end
