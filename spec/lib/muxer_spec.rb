require 'rails_helper'
require 'muxer'

RSpec.describe Muxer do
  let(:audio) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'the-more-you-know-audio.mp4')) }
  let(:video) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'test.mp4')) }
  
  subject(:muxer) { Muxer.new(audio, video, 5)  }

  describe '.mux' do
    it 'returns a tempfile' do
      expect(Muxer.mux(audio, video, 1)).to be_a(Tempfile)
    end
  end

  describe '#mux' do
    it 'uses the specified offset' do
      expect(Open3).to receive(:capture3).with(/-ss 5/)
      muxer.mux
    end

    it 'logs the ffmpeg output' do
      expect(Rails.logger).to receive(:info).with(/muxing overhead/)
      muxer.mux
    end
  end
end
