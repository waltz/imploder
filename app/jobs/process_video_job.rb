require 'gif_processor'
require 'youtube_downloader'
require 'muxer'

class ProcessVideoJob < ApplicationJob
  class ProcessVideo < Struct.new(:video_id)
    def process
      begin
        video.clip = clip
        video.clip_derivatives!
        video.status = 'ready'
        video.save
      rescue StandardError => e
        video.update!(status: 'error')
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join('\n'))
        Rails.logger.error("There was a problem processing video with video_id=#{video.id}")
      end
    end

    def clip
      @clip ||= Muxer.mux(youtube_audio, gif_clip, video.audio_start_delay)
    end

    def youtube_audio
      @youtube_audio ||= YoutubeDownloader.download(video.youtube_url)
    end

    def gif_clip
      @gif_clip ||= GifProcessor.process(video.gif_url)
    end

    def video
      @video ||= Video.find(video_id.to_i)
    end
  end

  def perform(video_id)
    ProcessVideo.new(video_id).process
  end
end
