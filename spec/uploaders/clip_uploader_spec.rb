require 'rails_helper'

RSpec.describe ClipUploader do
  let(:file) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'test.mp4')) }
  let(:uploader) { ClipUploader.new(:cache) }
  let(:upload) { uploader.upload(file) }

  describe '#upload' do
    it 'uploads the clip' do
      expect(upload.size).to eq(24884)
    end
  end
end
