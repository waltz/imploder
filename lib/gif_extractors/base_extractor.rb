require Rails.root.join('lib', 'gif_extractors', 'imgur_extractor')
require Rails.root.join('lib', 'gif_extractors', 'tenor_extractor')

module GIFExtractors
  EXTRACTORS = [GIFExtractors::ImgurExtractor, GIFExtractors::TenorExtractor]

  class GIFExtractors::BaseExtractor
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def content_url
      GIFExtractors::EXTRACTORS.map do |extractor_klass|
        extractor_klass.new(url).content_url
      end.first
    end
  end
end