module GIFExtractors
  class ImgurExtractor
    # https://imgur.com/gallery/WMTeuZl

    attr_accessor :url

    def initialize(url)
      @url = URI.parse(url)
    end

    def content_url
      return url.to_s if url.host.split('.').first == 'i'
      return nil unless url.path.include?("gallery")

      image_id = url.path.split("/")[2]
      "https://i.imgur.com/#{image_id}.mp4"
    end

    def can_read?
      url.host == "imgur.com"
    end
  end
end