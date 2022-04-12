require 'rails_helper'
require './lib/gif_extractors/tenor_extractor'

RSpec.describe GIFExtractors::TenorExtractor do
  let(:url) { 'https://tenor.com/view/napoleon-dynamite-yes-score-excited-success-gif-4398883' }
  let(:extractor) { GIFExtractors::TenorExtractor.new(url) }

  describe "#content_url", :vcr do
    it "links to the data" do
      expect(extractor.content_url).to eq('https://c.tenor.com/4ghViaV0SH0AAAAC/napoleon-dynamite-yes.gif')
    end
  end
end
