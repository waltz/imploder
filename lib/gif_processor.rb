require 'open3'
require 'gif_extractors/base_extractor'

class GifProcessor
  class ConversionError < StandardError; end

  attr_accessor :gif_url

  def initialize(gif_url)
    @gif_url = gif_url
    Rails.logger.info("Initialized gif processor for url=#{gif_url}")
  end

  def self.process(gif_url)
    processor = self.new(gif_url)
    processor.convert(processor.download)
  end

  def download
    @download ||= begin
      Rails.logger.info("Attempting to extract gif with url=#{gif_url}")
      content_url = GIFExtractors::BaseExtractor.new(gif_url).content_url
      Rails.logger.info("Found content_url=#{content_url}")
      uri = URI.parse(content_url)
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
    stderr, stdout, status = Open3.capture3("ffmpeg -i #{clean_path} #{ffmpeg_options} #{destination.path}")

    Rails.logger.info("Processing gif")

    if status.success?
      Rails.logger.info("Successfully processed gif")
    else
      Rails.logger.error(stdout)
      Rails.logger.error(stderr)
      Rails.logger.error("Failed to process gif")
      raise GifProcessor::ConversionError.new(stdout)
    end

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
