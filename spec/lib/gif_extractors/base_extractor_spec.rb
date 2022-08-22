require 'rails_helper'
require './lib/gif_extractors/base_extractor'

RSpec.describe GIFExtractors::BaseExtractor do
  let(:url) { "https://imgur.com/gallery/WMTeuZl" }

  describe "#content_url" do
    it 'extracts the content url' do
      expect(GIFExtractors::BaseExtractor.new(url).content_url).to include("https")
    end
  end
end