require 'open3'

class YoutubeDownloaderError < StandardError; end

class YoutubeDownloader
  def self.download(video_url)
    destination = Tempfile.new
    _, stderr, status = Open3.capture3("youtube-dl -o - --format bestaudio #{video_url} > #{destination.path}")
    Rails.logger.info(stderr)
    raise YoutubeDownloaderError.new(stderr) if status != 0
    destination
  end
end
