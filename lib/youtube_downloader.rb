require 'open3'

class YoutubeDownloader
  def self.download(video_url)
    destination = Tempfile.new
    _, stderr, _ = Open3.capture3("youtube-dl -o - --format bestaudio #{video_url} > #{destination.path}")
    Rails.logger.info(stderr)
    destination
  end
end
