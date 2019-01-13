require 'rails_helper'

RSpec.describe YoutubeDownloader do
  let(:the_more_you_know_video_url) { 'https://www.youtube.com/watch?v=Zmvt7yFTtt8' }

  describe '.download' do
    it 'calls youtube-dl' do
      expect(Open3).to receive(:capture3).with(/youtube-dl -o - --format bestaudio/).and_return(['', 'hi', ''])
      YoutubeDownloader.download(the_more_you_know_video_url)
    end
    
    it 'logs the download command output' do
      expect(Open3).to receive(:capture3).and_return(['', 'wahoo it works', ''])
      expect(Rails.logger).to receive(:info).with(/wahoo/)
      YoutubeDownloader.download(the_more_you_know_video_url)
    end

    it 'returns a tempfile' do
      expect(YoutubeDownloader.download(the_more_you_know_video_url)).to be_a(Tempfile)
    end
  end
end

