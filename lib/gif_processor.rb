require 'open3'
require 'gif_extractors/base_extractor'

class GifProcessor
  class ConversionError < StandardError; end
  class DownloadError < StandardError; end
  class EmptyFileError < StandardError; end

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
    Rails.logger.info("Attempting to extract gif with url=#{gif_url}")
    content_url = GIFExtractors::BaseExtractor.new(gif_url).content_url
    Rails.logger.info("Found content_url=#{content_url}")

    tempfile = Tempfile.new
    stderr, stdout, status = Open3.capture3("curl -L #{content_url} > #{tempfile.path}")

    if status.success?
      Rails.logger.info("Successfully downloaded url=#{content_url}")
    else
      Rails.logger.error(stderr)
      Rails.logger.error(stdout)
      Rails.logger.error("Failed to download url=#{content_url}")
      raise GifProcessor::DownloadError
    end

    raise GifProcessor::EmptyFileError if tempfile.length.zero?

    tempfile
  end

  def convert(file)
    clean_path = Shellwords.escape(file.path)
    clean_destination_path = Shellwords.escape(destination.path)
    stderr, stdout, status = Open3.capture3("ffmpeg -i #{clean_path} #{ffmpeg_options} #{clean_destination_path}")

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
