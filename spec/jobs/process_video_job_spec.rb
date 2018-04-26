require 'rails_helper'

RSpec.describe ProcessVideoJob, type: :job do
  subject(:video) { FactoryBot.create(:video) }

  before do
    clear_enqueued_jobs
  end
  
  describe '.perform_later' do
    it 'enqueues a job' do
      ProcessVideoJob.perform_later(video.id)
      expect(ProcessVideoJob).to have_been_enqueued
    end

    it 'sets the video status when it finishes' do
      perform_enqueued_jobs do
        ProcessVideoJob.perform_later(video.id)
      end
      expect(video.reload.status).to eq('ready')
    end

    it 'adds a clip to the video' do
      perform_enqueued_jobs do
        ProcessVideoJob.perform_later(video.id)
      end
      expect(video.reload.clip.url).to be_present
    end
  end
end
