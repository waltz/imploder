class GIFExtractors::GiphyExtractor
  attr_accessor :url

  def initialize(url)
    @url = URI.parse(url)
  end

  def content_url
    path_chunks = url.path.split('/')

    # https://giphy.com/gifs/foxtv-amy-poehler-emmys-2015-3oEduZtPOv5OSecubu
    if path_chunks[1] == 'gifs'
      last_chunk = path_chunks.last
      slug = last_chunk.split('-').last
      return "https://i.giphy.com/media/#{slug}/giphy.mp4"
    end

    if path_chunks[1] == 'media'
      slug = path_chunks[2]
      return "https://i.giphy.com/media/#{slug}/giphy.mp4"
    end

    url.to_s
  end

  def can_read?
    url.host == 'giphy.com' || url.host == 'media.giphy.com'
  end
end