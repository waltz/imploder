require Rails.root.join('lib', 'gif_extractors', 'imgur_extractor')
require Rails.root.join('lib', 'gif_extractors', 'tenor_extractor')

module GIFExtractors
  EXTRACTORS = [GIFExtractors::ImgurExtractor, GIFExtractors::TenorExtractor]

  class NoResultsFoundError < StandardError; end

  class GIFExtractors::BaseExtractor
    attr_accessor :url

    def initialize(url)
      Rails.logger.info("Extracting media URL for input url=#{url}")
      @url = url
    end

    def content_url
      possible_content_urls = GIFExtractors::EXTRACTORS.map do |extractor_klass|
        { extractor: extractor_klass, content_url: extractor_klass.new(url).content_url }
      end

      Rails.logger.info("Found candidates:")
      Rails.logger.info(possible_content_urls.inspect)

      results = possible_content_urls.reject { |u| u[:content_url].nil? }

      raise NoResultsFoundError if results.empty?

      final_choice = results.first[:content_url]

      Rails.logger.info("Choosing url=#{final_choice}")

      final_choice
    end
  end
end