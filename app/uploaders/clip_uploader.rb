require 'streamio-ffmpeg'

class ClipUploader < Shrine
  Attacher.derivatives do |original|
    movie = FFMPEG::Movie.new(original.path)
    capture_at = movie.duration / 2
    thumbnail = Tempfile.new(binmode: true)
   
    movie.screenshot(thumbnail.path, seek_time: capture_at)

    { thumbnail: thumbnail }
  end
end
