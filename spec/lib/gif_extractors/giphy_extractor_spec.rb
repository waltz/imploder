require 'rails_helper'
require './lib/gif_extractors/giphy_extractor'

RSpec.describe GIFExtractors::GiphyExtractor do
  let(:our_url) { 'https://media.giphy.com/media/NJA9m3pGDXoFmvpSq1/giphy.gif' }

  describe "#content_url" do
    let(:extractor) { GIFExtractors::GiphyExtractor.new(our_url) }

    it "returns the url for the actual gif data" do
      expect(extractor.content_url).to eq('https://i.giphy.com/media/NJA9m3pGDXoFmvpSq1/giphy.mp4')
    end
  end

  describe "#can_read?" do
    it "can read giphy urls" do
      expect(GIFExtractors::GiphyExtractor.new(our_url).can_read?).to eq(true)
    end
  end
end