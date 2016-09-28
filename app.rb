require 'sinatra/base'

class ExportGifSound < Sinatra::Base
  # https://gifsound.com/?gif=i.imgur.com/bYmN79L.gif&v=bWMw4vE3J8s&s=12
  get '/' do
    gif_url = params[:gif]
    youtube_id = params[:v]
    youtube_url = "http://www.youtube.com/watch?v=#{youtube_id}"
    youtube_video_start_delay = 0 || params[:s]

    did_converting_work = system("./converter.sh #{gif_url} #{youtube_url} #{youtube_video_start_delay}")

    if did_converting_work
      send_file "out.mp4"
    else
      "damn no dice"
    end
  end

  run! if app_file == $0
end
