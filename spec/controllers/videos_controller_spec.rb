require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  it { is_expected.to route(:get, '/').to('videos#new') }
  it { is_expected.to route(:post, '/videos').to('videos#create') }
  it { is_expected.to route(:get, '/videos/2').to('videos#show', id: 2) }

  describe 'GET #new' do
    context 'without any url parameters' do
      it 'renders the new page' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'with gifsound.com style url parameters' do
      before do
        get :new, params: { gif: 'things', v: 'great-id' }
      end

      it 'redirects to the video page' do
        expect(response).to redirect_to(video_path(assigns(:video).id))
      end

      it 'has the right video id' do
        expect(assigns(:video).youtube_url).to eq('https://www.youtube.com/watch?v=great-id')
      end

      it 'has the right gif url' do
        expect(assigns(:video).gif_url).to eq('things')
      end

      it 'processes the video' do
        expect(ProcessVideoJob).to receive(:perform_later)
        get :new, params: { gif: 'things', v: 'great-id' }
      end
    end
  end
end
