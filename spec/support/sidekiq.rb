require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
