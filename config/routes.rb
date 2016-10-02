require 'sidekiq/web'

Rails.application.routes.draw do
  root 'videos#new'
  resources :videos, only: [ :new, :show ] do
    member do
      get :status
    end
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?

  mount Sidekiq::Web => '/sidekiq'
end
