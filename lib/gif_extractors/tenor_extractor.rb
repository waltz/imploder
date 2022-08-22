require 'open-uri'

module GIFExtractors
  class TenorExtractor
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def content_url
      return nil unless url.include?('tenor.com')

      selector = '#single-gif-container > div:nth-child(1) > meta:nth-child(10)'
      page = Nokogiri::HTML.parse(open(url))
      element = page.css(selector).first
      element["content"]
    end
  end
end