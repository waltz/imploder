require_relative './config/environment'
require 'sinatra/base'
require_relative './app/jobs/process_video_job.rb'

class ExportGifSound < Sinatra::Base
  # https://gifsound.com/?gif=i.imgur.com/bYmN79L.gif&v=bWMw4vE3J8s&s=12
  get '/' do
    ProcessVideoJob.perform_async(params)

    "thanks, we're processing your request"
  end
end
