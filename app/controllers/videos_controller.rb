class VideosController < ApplicationController
  def new
    # https://gifsound.com/?gif=i.imgur.com/bYmN79L.gif&v=bWMw4vE3J8s&s=12
    p gifsound_params

    @video = Video.from_gifsound_params(gifsound_params)
    @video.save

    p @video.id

    ProcessVideoJob.perform_later(@video.id)
    redirect_to video_path(@video)
  end

  def show
    @video = Video.find(params[:id])
  end

  def status
    @video = Video.find(params[:id])
    render json: { status: @video.status }
  end

  private

  def gifsound_params
    params.permit(:gif, :v, :s, :gfycat, :gifv).to_hash
  end
end
