require 'sinatra/base'

class ExportGifSound < Sinatra::Base
  # https://gifsound.com/?gif=i.imgur.com/bYmN79L.gif&v=bWMw4vE3J8s&s=12
  get '/' do
    if params[:gifv]
      gif_url = "http://i.imgur.com/#{params[:gifv]}.mp4"
    else
      gif_url = params[:gif]
    end

    youtube_id = params[:v]
    youtube_url = "http://www.youtube.com/watch?v=#{youtube_id}"
    youtube_video_start_delay = params[:s] || 0

    command = "bash ./converter.sh #{gif_url} #{youtube_url} #{youtube_video_start_delay}"

    p "Current GIF url: #{gif_url}"
    p "Current YT start delay: #{youtube_video_start_delay}"
    p "conversion command: #{command}"

    if system(command)
      send_file "out.mp4"
    else
      "damn no dice"
    end
  end
end
