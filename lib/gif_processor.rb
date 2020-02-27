require 'open3'

class GifProcessor
  attr_accessor :gif_url

  def initialize(gif_url)
    @gif_url = gif_url
  end

  def self.process(gif_url)
    processor = self.new(gif_url)
    processor.convert(processor.download)
  end

  def download
    @download ||= begin
      uri = URI(gif_url)
      tempfile = Tempfile.new.tap(&:binmode)
      ssl = (uri.scheme == 'https')
      Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) do |http|
        request = Net::HTTP::Get.new(uri.path)
        http.request(request) do |response|
          response.read_body do |chunk|
            tempfile.write(chunk)
          end
        end
      end
      tempfile
    end
  end

  def convert(file)
    clean_path = Shellwords.escape(file.path)
    _, stderr, _ = Open3.capture3("ffmpeg -i #{clean_path} #{ffmpeg_options} #{destination.path}")
    Rails.logger.info(stderr)
    destination
  end

  private

  def destination
    @destination ||= Tempfile.new
  end

  def ffmpeg_options
    '-y -profile:v baseline -pix_fmt yuvj420p -r 30 -vf \'scale=trunc(iw/2)*2:trunc(ih/2)*2\' -f mp4'
  end
end
