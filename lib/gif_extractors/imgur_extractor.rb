module GIFExtractors
  class ImgurExtractor
    # TOOD: Imgur gallery urls are busted because the identifier for the gallery
    # no longer corresponds to a path to the media source.
    #
    # input: https://imgur.com/gallery/IFHnZ9s
    # output: https://i.imgur.com/yvMK5rI.mp4

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