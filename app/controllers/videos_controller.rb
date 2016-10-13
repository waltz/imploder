class VideosController < ApplicationController
  def new
    @video = Video.from_gifsound_params(gifsound_params)

    if @video.save
      ProcessVideoJob.perform_later(@video.id)
      redirect_to video_path(@video)
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  def status
    @video = Video.find(params[:id])
    render json: { status: @video.status }
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      ProcessVideoJob.perform_later(@video.id)
      redirect_to video_path(@video)
    else
      render :new
    end
  end

  private

  def gifsound_params
    params.slice(:gif, :v, :s, :gfycat, :gifv)
  end

  def video_params
    params.require(:video).permit(:youtube_url, :gif_url)
  end
end
