require 'rails_helper'
require './lib/gif_extractors/base_extractor'

RSpec.describe GIFExtractors::BaseExtractor do
  let(:url) { 'https://imgur.com/gallery/WMTeuZl' }

  describe '#content_url', :vcr do
    it 'extracts the content url' do
      expect(GIFExtractors::BaseExtractor.new(url).content_url).to include('https')
    end

    context 'when the url matches two extractors' do
      let(:url) { 'https://tenor.com/view/i-love-iran-gif-19136551' }

      it 'extracts the content url' do
        expect(GIFExtractors::BaseExtractor.new(url).content_url).to include('tenor')
      end
    end
  end
end