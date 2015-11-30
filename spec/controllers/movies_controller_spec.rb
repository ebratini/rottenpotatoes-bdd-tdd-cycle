require 'rails_helper'
 
describe MoviesController do
  describe 'searching movies by director' do
    context 'movie has director info' do
      before :each do
        @fake_movie = double('movie1', id: '1')
        @fake_results = [double('movie2'), double('movie3')]
      end
      it 'should call model method that perform movie search by director' do
        # Movie.should_receive(:find_by_same_director)
        expect(Movie).to receive(:find_by_same_director)
        get :similar_director, id: @fake_movie.id
      end
      it 'should select the Similar Movies template for rendering' do
        # Movie.stub(:find_by_same_director).and_return(@fake_results)
        allow(Movie).to receive(:find_by_same_director).and_return(@fake_results)
        get :similar_director, id: @fake_movie.id
        expect(response).to render_template(:similar_director)
      end
      it 'should make the search results available to that template' do
        allow(Movie).to receive(:find_by_same_director).and_return(@fake_results)
        get :similar_director, id: @fake_movie.id
        expect(assigns(:movies)).to eq @fake_results
      end
    end
    context 'movie has *no director info' do
      fixtures :movies
      # before :each do
      #   @fake_movie = double('movie1', id: '1')
      # end
      # it 'should raise exception if no director info found' do
      #   allow(Movie).to receive(:find_by_same_director).and_raise(Movie::NoDirectorInfoFound)
      #   expect { get :similar_director, id: @fake_movie.id }.to raise_error(Movie::NoDirectorInfoFound)
      # end
      it 'should redirect to home page when no director info found' do
        primer = movies(:primer)
        get :similar_director, id: primer.id
        expect(response).to redirect_to(root_url)
      end
    end
  end
end