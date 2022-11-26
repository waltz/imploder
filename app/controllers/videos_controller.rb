class VideosController < ApplicationController
  def index
    if params[:v]
      @video = Video.from_gifsound_params(gifsound_params)
      if @video.save
        ProcessVideoJob.perform_later(@video.id)
        redirect_to video_path(@video)
      end
    else
      @videos = Video.ready.order(created_at: :desc).limit(10)
    end
  end

  def new
    @video = Video.new
  end

  def show
    @video = Video.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @video }
    end
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
    params.require(:video).permit(:youtube_url, :gif_url, :audio_start_delay)
  end
end
