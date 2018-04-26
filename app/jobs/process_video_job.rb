class ProcessVideoJob < ApplicationJob
  def perform(video_id)
    video = Video.find(video_id.to_i)
    destination_path = Rails.root.join('tmp', "#{video.id}.mp4")
    system("./bin/converter #{video.gif_url} #{video.youtube_url} #{video.audio_start_delay} #{destination_path} &>/dev/null")
    video.status = 'ready'
    video.clip = File.open(destination_path)
    video.save!
  end
end
