require 'shrine'

if Rails.env.test?
  require 'shrine/storage/memory'
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
elsif Rails.env.production?
  require 'shrine/storage/s3'
  s3_options = {
    access_key_id: Rails.application.secrets.aws_access_key_id,
    secret_access_key: Rails.application.secrets.aws_secret_access_key,
    bucket: Rails.application.secrets.s3_bucket,
    region: 'us-west-1',
  }
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)
  }
else
  require 'shrine/storage/file_system'
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :determine_mime_type
Shrine.plugin :derivatives
