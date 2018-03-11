require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  it { is_expected.to route(:get, '/').to('videos#index') }
  it { is_expected.to route(:get, '/videos/new').to('videos#new') }
  it { is_expected.to route(:post, '/videos').to('videos#create') }
  it { is_expected.to route(:get, '/videos/2').to('videos#show', id: 2) }

  describe 'GET #index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'when there are videos' do
      before do
        FactoryBot.create_list(:video, 15)
      end

      it 'returns the first ten videos' do
        get :index
        expect(assigns(:videos).length).to eq(10)
      end
    end

    context 'with gifsound.com style url parameters' do
      before do
        get :index, params: { gif: 'things', v: 'great-id' }
      end

      it 'redirects to the video page' do
        expect(response).to redirect_to(video_path(assigns(:video).id))
      end

      it 'has the right youtube url' do
        expect(assigns(:video).youtube_url).to eq('https://www.youtube.com/watch?v=great-id')
      end

      it 'has the right gif url' do
        expect(assigns(:video).gif_url).to eq('things')
      end

      it 'enqueues the video for processesing' do
        expect(ProcessVideoJob).to receive(:perform_later)
        get :index, params: { gif: 'things', v: 'great-id' }
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    let!(:video) { FactoryBot.create(:video, gif_url: 'http://x.com/a.gif') }

    it 'renders a video page' do
      get :show, params: {id: video.id}
      expect(assigns(:video).gif_url).to eq('http://x.com/a.gif')
    end
  end
end
