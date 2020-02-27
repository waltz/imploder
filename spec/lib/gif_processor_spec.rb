require 'rails_helper'
require './lib/gif_processor'

RSpec.describe GifProcessor do
  let(:gif_url) { 'http://i.imgur.com/O1hpXe4.gif' }
  subject(:gif_processor) { GifProcessor.new(gif_url) }

  describe '.process', :vcr do
    it 'returns a tempfile' do
      expect(GifProcessor.process(gif_url)).to be_a(Tempfile) 
    end
  end
  
  describe '#download', :vcr do
    it 'uses net http to download the gif' do
      expect(Net::HTTP).to receive(:start)
      gif_processor.download
    end

    it 'writes the file to disk' do
      expect(gif_processor.download.path).to be_present
    end
  end

  describe '#convert' do
    let(:gif) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'cyberpunx.gif')) }

    it 'calls ffmpeg' do
      expect(Open3).to receive(:capture3).with(/ffmpeg -i/)
      gif_processor.convert(gif)
    end

    it 'logs to rails' do
      expect(Rails.logger).to receive(:info).with(/mp4/)
      gif_processor.convert(gif)
    end
  end
end
