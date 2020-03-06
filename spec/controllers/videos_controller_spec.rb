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
      def make_request(params = {})
        get :index, params: { gif: 'things', v: 'great-id' }.merge(params)
      end

      it 'redirects to the video page' do
        make_request
        expect(response).to redirect_to(video_path(assigns(:video).id))
      end

      it 'has the right youtube url' do
        make_request
        expect(assigns(:video).youtube_url).to eq('https://www.youtube.com/watch?v=great-id')
      end

      it 'has the right gif url' do
        make_request
        expect(assigns(:video).gif_url).to eq('things')
      end

      it 'enqueues the video for processesing' do
        make_request
        expect(ProcessVideoJob).to receive(:perform_later)
        get :index, params: { gif: 'things', v: 'great-id' }
      end

      context 'when the video already exists' do
        let(:duplicate_params) { { gif_url: 'taco', youtube_url: 'https://www.youtube.com/watch?v=torta', audio_start_delay: 66 } }
        let!(:another_video) { FactoryBot.create(:video, duplicate_params) }
        
        it 'redirects to the existing video page' do
          make_request({ gif: duplicate_params[:gif_url], v: 'torta', s: duplicate_params[:audio_start_delay] })

          expect(response).to redirect_to(video_path(another_video.id))
        end
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

    context 'when the request asks for json' do
      it 'renders the video attributes' do
        get :show, params: {id: video.id, format: :json}
        expect(JSON.parse(response.body)['created_at']).to be_present
      end
    end
  end
end
