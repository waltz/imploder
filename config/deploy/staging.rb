server ENV.fetch('STAGING_HOST'), user: 'deploy', roles: %w{app db web}
set :rails_env, 'production'
