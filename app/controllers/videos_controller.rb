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

  private

  def gifsound_params
    params.permit(:gif, :v, :s, :gfycat, :gifv).to_hash
  end
end
