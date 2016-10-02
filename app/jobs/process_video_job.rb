class ProcessVideoJob < ApplicationJob
  def perform(video_id)
    video = Video.find(video_id)
    destination_path = Rails.root.join('public', 'videos', "#{video.id}.mp4")
    system("./bin/converter #{video.gif_url} #{video.youtube_url} #{video.audio_start_delay} #{destination_path}")
    video.update!({ status: 'ready' })
  end
end
