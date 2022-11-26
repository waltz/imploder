namespace :test_downloader do
  def redirect_logs_to_stdout
    Rails.logger.extend(
      ActiveSupport::Logger.broadcast(
        ActiveSupport::Logger.new($stdout)
      )
    )
  end

  desc "Try to download a video with the downloader class. Takes $URL as an env var"
  task :go => :environment do
    redirect_logs_to_stdout

    url = ENV.fetch('URL')
    youtube_downloader = YoutubeDownloader.download(url)
    ap youtube_downloader
  end

  desc "Try to download and process a gif. Takes $URL as an env var"
  task :gif => :environment do
    redirect_logs_to_stdout

    url = ENV.fetch('URL')
    gif_processor = GifProcessor.process(url)
    ap gif_processor
  end

  desc "Finds a media source url given a url to a page for a gif. Takes $URL as an env var"
  task :extract_gif_url => :environment do
    redirect_logs_to_stdout

    url = ENV.fetch('URL')
    base_extractor = GIFExtractors::BaseExtractor.new(url).content_url
    ap base_extractor
  end
end
