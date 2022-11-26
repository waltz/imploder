require 'open3'

class YoutubeDownloader
  class Error < StandardError; end

  def self.download(video_url)
    Rails.logger.info("Beginning to download: #{video_url}")
    destination = Tempfile.new
    stdout, stderr, status = Open3.capture3("yt-dlp -o - --format bestaudio #{video_url} > #{destination.path}")

    Rails.logger.info(stdout)

    if status.success?
      Rails.logger.info("Successfully downloaded: #{video_url}")
    else
      Rails.logger.error("There was a problem downloading: #{video_url}")
      Rails.logger.error(stderr)
      raise YoutubeDownloader::Error.new(stderr)
    end

    destination
  end
end
