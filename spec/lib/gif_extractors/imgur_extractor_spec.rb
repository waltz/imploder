require 'rails_helper'
require './lib/gif_extractors/imgur_extractor'

RSpec.describe GIFExtractors::ImgurExtractor do
  let(:our_url) { "https://imgur.com/gallery/WMTeuZl" }

  describe "#content_url" do
    let(:extractor) { GIFExtractors::ImgurExtractor.new(our_url) }

    it "returns the url for the actual gif data" do
      expect(extractor.content_url).to eq("https://i.imgur.com/WMTeuZl.mp4")
    end

    context 'when the url is already a direct url' do
      let(:our_url) { 'http://i.imgur.com/O1hpXe4.gif' }

      it 'returns the same content url' do
        expect(extractor.content_url).to eq('http://i.imgur.com/O1hpXe4.gif')
      end
    end
  end

  describe "#can_read?" do
    it "can read imgur urls" do
      expect(GIFExtractors::ImgurExtractor.new(our_url).can_read?).to eq(true)
    end
  end
end