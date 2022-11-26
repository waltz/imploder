require 'rails_helper'

RSpec.describe YoutubeDownloader do
  let(:the_more_you_know_video_url) { 'https://www.youtube.com/watch?v=Zmvt7yFTtt8' }

  describe '.download' do
    before do
      allow(Open3).to receive(:capture3).and_return(['fake-stdout', 'fake-stderr', double(:status, success?: true)])
    end

    it 'calls yt-dlp' do
      YoutubeDownloader.download(the_more_you_know_video_url)
      expect(Open3).to have_received(:capture3).with(/yt-dlp -o - --format bestaudio/)
    end

    it 'logs the download command output' do
      info_logger = double(:logger, info: "thanks for logging")
      allow(Rails).to receive(:logger).and_return(info_logger)
      YoutubeDownloader.download(the_more_you_know_video_url)

      expect(Rails.logger).to have_received(:info).with(/fake-stdout/)
      expect(Rails.logger).to have_received(:info).with(/Successfully downloaded/)
    end

    it 'returns a tempfile' do
      expect(YoutubeDownloader.download(the_more_you_know_video_url)).to be_a(Tempfile)
    end

    context 'when youtube-dl blows up' do
      before do
        allow(Open3).to receive(:capture3).and_return(['', 'oh no', double(:status, success?: false)])
      end

      it 'raises an exception' do
        expect { YoutubeDownloader.download(the_more_you_know_video_url) }.to raise_error(YoutubeDownloader::Error)
      end
    end
  end
end

