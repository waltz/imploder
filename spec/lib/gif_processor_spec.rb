require 'rails_helper'
require './lib/gif_processor'

RSpec.describe GifProcessor do
  let(:gif_url) { 'http://i.imgur.com/O1hpXe4.gif' }
  subject(:gif_processor) { GifProcessor.new(gif_url) }

  before do
    allow(Rails.logger).to receive(:info)
  end

  describe '.process', :vcr do
    it 'returns a tempfile' do
      expect(GifProcessor.process(gif_url)).to be_a(Tempfile)
    end
  end

  describe '#download', :vcr do
    let(:fake_file) { double('tempfile', { length: 123, path: "/tmp/fake.mp4" }) }

    before do
      allow(Tempfile).to receive(:new).and_return(fake_file)

      allow(Open3).to receive(:capture3).and_return(['fake-stdout', 'fake-stderr', double(:status, success?: true)])
    end

    it 'writes the file to disk' do
      expect(gif_processor.download.path).to be_present
    end

    context 'when the download fails' do
      before do
        allow(Open3).to receive(:capture3).and_return(['fake-stdout', 'fake-stderr', double(:status, success?: false)])
      end

      it 'raises a downloader error' do
        expect { gif_processor.download }.to raise_error(GifProcessor::DownloadError)
      end
    end

    context 'when the downloaded file is empty' do
      let(:fake_file) { double('tempfile', { length: 0, path: "/tmp/fake.mp4" }) }

      it 'raises an empty file error' do
        expect { gif_processor.download }.to raise_error(GifProcessor::EmptyFileError)
      end
    end
  end

  describe '#convert' do
    let(:gif) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'from-giphy.mp4')) }

    before do
      allow(Open3).to receive(:capture3).and_return(['fake-stdout', 'fake-stderr', double(:status, success?: true)])
    end

    it 'calls ffmpeg' do
      gif_processor.convert(gif)
      expect(Open3).to have_received(:capture3).with(/ffmpeg -i/)
    end

    it 'logs to rails' do
      gif_processor.convert(gif)
      expect(Rails.logger).to have_received(:info).with(/Processing gif/)
    end

    context 'when conversion fails' do
      before do
        allow(Open3).to receive(:capture3).and_return(['fake-stdout', 'fake-stderr', double(:status, success?: false)])
      end

      it 'raises' do
        expect { gif_processor.convert(gif) }.to raise_error(GifProcessor::ConversionError)
      end
    end
  end
end
