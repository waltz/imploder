class Video < ApplicationRecord
  def self.from_gifsound_params(params)
    gif_url = if params['gfycat']
                "https://giant.gfycat.com/#{params['gfycat']}.mp4"
              elsif params['gifv']
                "https://i.imgur.com/#{params['gifv']}.mp4"
              else params['gif']
                params['gif']
              end
    new(
      gif_url: gif_url,
      youtube_url: "https://www.youtube.com/watch?v=#{params['v']}",
      audio_start_delay: params['s'] || 0
    )
  end

  def ready?
    status == 'ready'
  end
end
