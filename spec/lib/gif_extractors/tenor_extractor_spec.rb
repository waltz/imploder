require 'rails_helper'
require './lib/gif_extractors/tenor_extractor'

RSpec.describe GIFExtractors::TenorExtractor do
  describe "#content_url", :vcr do
    it "extracts napoleon dynamite" do
      url = 'https://tenor.com/view/napoleon-dynamite-yes-score-excited-success-gif-4398883'
      content_url = GIFExtractors::TenorExtractor.new(url).content_url
      expect(content_url).to eq('https://media.tenor.com/4ghViaV0SH0AAAAC/napoleon-dynamite-yes.gif')
    end

    it "extracts an iran meme" do
      url = 'https://tenor.com/view/i-love-iran-gif-19136551'
      content_url = GIFExtractors::TenorExtractor.new(url).content_url
      expect(content_url).to eq('https://media.tenor.com/lz0AdR6wU1cAAAAC/i-love-iran.gif')
    end
  end
end
