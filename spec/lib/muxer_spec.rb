require 'rails_helper'
require 'muxer'

RSpec.describe Muxer do
  let(:audio) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'the-more-you-know-audio.mp4')) }
  let(:video) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'test.mp4')) }

  subject(:muxer) { Muxer.new(audio, video, 5) }

  describe '.mux' do
    it 'returns a tempfile' do
      expect(Muxer.mux(audio, video, 1)).to be_a(Tempfile)
    end
  end

  describe '#mux' do
    before do
      fake_process_status = double(:process_status, success?: true)
      allow(Open3).to receive(:capture3).and_return(['fake-stderr', 'fake-stdout', fake_process_status])
    end

    it 'uses the specified offset' do
      expect(Open3).to receive(:capture3).with(/-ss 5/)
      muxer.mux
    end

    it 'logs the ffmpeg output' do
      allow(Rails.logger).to receive(:info)

      muxer.mux

      expect(Rails.logger).to have_received(:info).with(/Muxing file/)
      expect(Rails.logger).to have_received(:info).with(/was successful/)
    end

    context 'when there is an error' do
      before do
        fake_process_status = double(:process_status, success?: false)
        allow(Open3).to receive(:capture3).and_return(['fake-stderr', 'fake-stdout', fake_process_status])
      end

      it 'logs the error message' do
        allow(Rails.logger).to receive(:error)

        muxer.mux rescue Muxer::Error

        expect(Rails.logger).to have_received(:error).with(/problem/)
        expect(Rails.logger).to have_received(:error).with('fake-stderr')
        expect(Rails.logger).to have_received(:error).with('fake-stdout')
      end
    end
  end
end
