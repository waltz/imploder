require 'rails_helper'

RSpec.describe YoutubeDownloader do
  let(:the_more_you_know_video_url) { 'https://www.youtube.com/watch?v=Zmvt7yFTtt8' }

  describe '.download' do
    before do
      allow(Open3).to receive(:capture3).and_return(['', 'wahoo', 0])
    end

    it 'calls youtube-dl' do
      YoutubeDownloader.download(the_more_you_know_video_url)
      expect(Open3).to have_received(:capture3).with(/youtube-dl -o - --format bestaudio/)
    end
    
    it 'logs the download command output' do
      expect(Rails.logger).to receive(:info).with(/wahoo/)
      YoutubeDownloader.download(the_more_you_know_video_url)
    end

    it 'returns a tempfile' do
      expect(YoutubeDownloader.download(the_more_you_know_video_url)).to be_a(Tempfile)
    end

    context 'when youtube-dl blows up' do
      before do
        allow(Open3).to receive(:capture3).and_return(['', 'oh no', 1])
      end

      it 'raises an exception' do
        expect { YoutubeDownloader.download(the_more_you_know_video_url) }.to raise_error(YoutubeDownloaderError)
      end
    end
  end
end

