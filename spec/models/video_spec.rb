require 'rails_helper'

RSpec.describe Video, type: :model do
  subject(:video) { FactoryBot.create(:video) }

  it { is_expected.to validate_presence_of(:gif_url) }
  it { is_expected.to validate_presence_of(:youtube_url) }

  describe '.from_gifsound_params' do
    let(:video) { Video.from_gifsound_params(params) }

    context 'with some basic params' do
      let(:params) { { gif: 'things.com', v: 'blammo', s: '3' }}

      it 'sets the gif url' do
        expect(video.gif_url).to eq('things.com')
      end

      it 'sets the video url' do
        expect(video.youtube_url).to eq('https://www.youtube.com/watch?v=blammo')
      end

      it 'sets the audio start delay' do
        expect(video.audio_start_delay).to eq(3)
      end
    end

    context 'with a gfycat parameter' do
      let(:params) { { gfycat: 'barf', v: 'blammo', s: '3' }}

      it 'sets the gif url' do
        expect(video.gif_url).to eq('https://giant.gfycat.com/barf.mp4')
      end
    end

    context 'with a gifv parameter' do
      let(:params) { { gifv: 'barf', v: 'blammo', s: '3' }}

      it 'sets the gif url' do
        expect(video.gif_url).to eq('https://i.imgur.com/barf.mp4')
      end
    end

    context 'with no audio offset' do
      let(:params) { { gfycat: 'barf', v: 'blammo', s: '' }}

      it 'sets the audio offset to zero' do
        expect(video.audio_start_delay).to eq(0)
      end
    end
  end

  describe '#ready?' do
    context 'when the field is blank' do
      it 'is not ready' do
        expect(video).not_to be_ready
      end
    end

    context 'when the field is set to ready' do
      let(:video) { FactoryBot.create(:video, status: 'ready') }

      it 'is ready' do
        expect(video).to be_ready
      end
    end
  end
end
