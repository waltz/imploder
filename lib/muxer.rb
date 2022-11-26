require 'open3'

class Muxer
  attr_accessor :audio, :video, :offset

  class Error < StandardError; end

  def self.mux(audio, video, offset = 0)
    self.new(audio, video, offset).mux
  end

  def initialize(audio, video, offset = 0)
    @audio, @video, @offset = audio, video, offset
  end

  def mux
    Rails.logger.info("Muxing file")
    stderr, stdout, status = Open3.capture3(command)

    if status.success?
      Rails.logger.info("Muxing was successful")
    else
      Rails.logger.error("There was a problem muxing!")
      Rails.logger.error(stderr)
      Rails.logger.error(stdout)
      raise Muxer::Error.new(stderr)
    end

    destination
  end

  private

  def command
    "ffmpeg -y -i #{video.path} -ss #{offset} -i #{audio.path} -c:v h264 -c:a aac -map 0:v:0 -map 1:a:0 -shortest -f mp4 -strict experimental #{destination.path}"
  end

  def destination
    @destination ||= Tempfile.new
  end
end
