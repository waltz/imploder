require 'content_disposition'

class Video < ApplicationRecord
  include ClipUploader::Attachment.new(:clip)

  validates :gif_url, presence: true
  validates :youtube_url, presence: true

  def self.from_gifsound_params(params)
    gif_url = if params[:gfycat]
                "https://giant.gfycat.com/#{params[:gfycat]}.mp4"
              elsif params[:gifv]
                "https://i.imgur.com/#{params[:gifv]}.mp4"
              else params[:gif]
                params[:gif]
              end
    new(
      gif_url: gif_url,
      youtube_url: "https://www.youtube.com/watch?v=#{params[:v]}",
      audio_start_delay: params[:s].blank? ? 0 : params[:s]
    )
  end

  def audio_start_delay
    read_attribute(:audio_start_delay) || 0
  end

  def ready?
    status == 'ready'
  end

  def attributes
    {
      id: id,
      created_at: created_at,
      updated_at: updated_at,
      status: status,
      clip_url: clip_url,
    }
  end

  def download_url
    clip.url({ response_content_disposition: ContentDisposition.format(disposition: 'attachment', filename: "implosion-#{id}.mp4") })
  end
end
