require Rails.root.join('lib', 'gif_extractors', 'imgur_extractor')

module GIFExtractors
  EXTRACTORS = [GIFExtractors::ImgurExtractor]

  class BaseExtractor
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