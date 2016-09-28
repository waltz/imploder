class ProcessVideoJob
  include SuckerPunch::Job

  def perform(params)
    if params[:gfycat]
      gif_url = "https://giant.gfycat.com/#{params[:gfycat]}.mp4"
    end

    if params[:gifv]
      gif_url = "http://i.imgur.com/#{params[:gifv]}.mp4"
    end

    if params[:gif]
      gif_url = params[:gif]
    end

    youtube_id = params[:v]
    youtube_url = "http://www.youtube.com/watch?v=#{youtube_id}"
    youtube_video_start_delay = params[:s] || 0

    command = "./converter.sh #{gif_url} #{youtube_url} #{youtube_video_start_delay}"

    p "Current GIF url: #{gif_url}"
    p "Current YT start delay: #{youtube_video_start_delay}"
    p "conversion command: #{command}"

    system(command)
  end
end
