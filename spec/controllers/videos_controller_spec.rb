require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #new' do
    context 'without any url parameters' do
      it 'renders the new page' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'with gifsound.com style url parameters' do
      it 'redirects to the video page' do
        get :new, params: { gif: 'things', v: 'youtube.com/foo' }
        expect(response).to redirect_to(video_path(assigns(:video).id))
      end
    end
  end
end
