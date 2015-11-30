require 'rails_helper'
 
describe MoviesController do
  fixtures :movies
  
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
      it 'should redirect to home page when no director info found' do
        primer = movies(:primer)
        get :similar_director, id: primer.id
        expect(response).to redirect_to(root_url)
      end
    end
  end
  describe 'movies sort/filter test' do
    it 'should sort by title' do
      get :index, sort: 'title'
      expect(response).to have_http_status(302)
      # expect(response).to be_success
      # expect(response).to redirect_to movies_path(sort: @sort, ratings: @ratings)
    end
    it 'should sort by release_date' do
      get :index, sort: 'release_date'
      expect(response).to have_http_status(302)
      # expect(response).to be_success
      # expect(response).to redirect_to movies_path(sort: @sort, ratings: @ratings)
    end
    it 'should filter movies to R rating' do
      get :index, ratings: @ratings
      expect(response).to be_success
      # expect(response).to redirect_to movies_path(ratings: @ratings)
    end
  end
  describe 'movies controller tests' do
    before :each do
      @memento = movies(:memento)
    end
    it 'should get index' do
      get :index
      expect(response).to render_template('index')
    end
    it 'should get movie details page(show)' do
      get :show, id: @memento
      expect(response).to render_template('show')
    end
    it 'should get edit page for movie' do
      get :edit, id: @memento
      expect(response).to render_template('edit')
    end
    it 'should create movie successfully' do
      post :create, movie: { title: 'Matrix', rating: 'R', release_date: '1999-03-31', director: 'Wachowski Bros' }
      expect(response).to redirect_to movies_path
    end
    it 'should update movie successfully' do
      patch :update, id: @memento, movie: { release_date: '2000-05-25' }
      expect(response).to redirect_to movie_path(@memento)
    end
    it 'should destroy movie successfully' do
      delete :destroy, id: @memento
      expect(response).to redirect_to movies_path
    end
  end
end