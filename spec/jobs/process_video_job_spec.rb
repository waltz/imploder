require 'rails_helper'

RSpec.describe ProcessVideoJob, :job, :vcr do
  subject(:job) { ProcessVideoJob.new }
  let(:video) { FactoryBot.create(:video) }
  let(:audio_track) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'the-more-you-know-audio.mp4')) }
  let(:video_track) { File.open(Rails.root.join('spec', 'support', 'fixtures', 'test.mp4')) }

  before do
    allow(YoutubeDownloader).to receive(:download).and_return(audio_track)
    allow(GifProcessor).to receive(:process).and_return(video_track)
  end

  describe '#perform' do
    context 'when the video does not exist' do    
      it 'blows up' do
        expect { job.perform(-1) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the video exists' do
      it 'sets the video status to ready' do
        job.perform(video.id)
        expect(video.reload.status).to eq('ready')
      end

      it 'adds a clip to the video' do
        job.perform(video.id)
        expect(video.reload.clip).to be_present
      end

      it 'makes a thumbnail for the video' do
        job.perform(video.id)
        expect(video.reload.clip_data.dig('derivatives', 'thumbnail')).to be_present
      end
    end
  end
end
