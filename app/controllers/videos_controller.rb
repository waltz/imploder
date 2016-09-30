class VideosController < ApplicationController
  def new
    # https://gifsound.com/?gif=i.imgur.com/bYmN79L.gif&v=bWMw4vE3J8s&s=12
    ProcessVideoJob.perform_later(video_params)
  end

  private

  def video_params
    params.permit(:gif, :v, :s, :gfycat, :gifv).to_hash
  end
end
