require 'streamio-ffmpeg'
require 'image_processing/mini_magick'

class ClipUploader < Shrine
  class DerivativesBuilder
    attr_accessor :original

    def initialize(original)
      @original = original
    end

    def build
      { thumbnail: thumbnail, homepage: homepage, twitter: twitter }
    end

    def thumbnail
      @thumbnail ||= begin
        movie = FFMPEG::Movie.new(original.path)
        capture_at = movie.duration / 2
        tempfile = Tempfile.new(binmode: true)
        tempfile.open

        movie.screenshot(tempfile.path, seek_time: capture_at)

        tempfile
      end
    end

    def homepage
      @homepage ||= begin
        ImageProcessing::MiniMagick
          .source(thumbnail)
          .convert('png')
          .resize_to_limit!(200, 200)
      end
    end
    
    def twitter 
      @twitter ||= begin
        chain = ImageProcessing::MiniMagick
          .source(thumbnail)
          .convert('png')
          .resize_to_limit!(300, 157)
      end
    end
  end

  Attacher.derivatives do |original|
    DerivativesBuilder.new(original).build
  end
end
