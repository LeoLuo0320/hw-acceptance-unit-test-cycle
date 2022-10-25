require 'spec_helper'
require 'rails_helper'

if RUBY_VERSION>='2.6.0'
    if Rails.version < '5'
      class ActionController::TestResponse < ActionDispatch::TestResponse
        def recycle!
          # hack to avoid MonitorMixin double-initialize error:
          @mon_mutex_owner_object_id = nil
          @mon_mutex = nil
          initialize
        end
      end
    else
      puts "Monkeypatch for ActionController::TestResponse no longer needed"
    end
end

describe MoviesController do
    describe 'find similar movies test' do
        let!(:movie1) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }
        let!(:movie2) { Movie.create!(title: 'TransformerII', director: 'Zijian Zhang') }
        let!(:movie3) { Movie.create!(title: 'Nil') }

        it 'should find similar movies if director exists' do
            movie = movie1
            get :search, { title: movie1.title }
            expect(assigns(:movies_with_same_director)).to eql([movie1.title, movie2.title])
        end

        it "should redirect to root_url if director is nil" do
            get :search, { title: 'Nil' }
            expect(response).to redirect_to(root_url) 
            expect(flash[:notice]).to eq("'Nil' has no director info")
        end
    end

    describe 'GET Index' do
        it 'should display index.html' do
            get :index
            expect(response).to render_template('index')
        end
    end

    describe 'Show' do
        let!(:movie) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }

        it 'should show the detail of the movie' do
            get :show, id: movie.id
            expect(assigns(:movie)).to eql(movie)
            expect(response).to render_template('show')
        end
    end

    describe 'Create' do
        it 'creates a new movie and redirects to the movie index page' do
            orig_movies_count = Movie.all.count
            post :create, movie: {:title=>"New Movie", :director=>"Zijian Zhang"}
            expect(Movie.all.count).to eq(orig_movies_count + 1)

            expect(response).to redirect_to(movies_url)
        end
    end

    describe 'DELETE' do
        let!(:movie) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }

        it 'deletes a movie and redirects to the home page and alert' do
            orig_movies_count = Movie.all.count
            delete :destroy, id: movie.id
            expect(Movie.all.count).to eq(orig_movies_count - 1)

            expect(response).to redirect_to(movies_path)
            expect(flash[:notice]).to eq("Movie 'Transformer' deleted.")
        end
    end

    describe 'Edit' do
        let!(:movie) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }

        before do
            get :edit, id: movie.id
        end

        it 'should edit a movie and redirect' do
            expect(assigns(:movie)).to eql(movie)
            expect(response).to render_template('edit')
        end
    end

    describe 'Update' do
        let!(:movie) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }

        it 'updates a movie and redirects to the movie page' do
            put :update, id: movie.id, movie: {:title=>"TransformerII"}
            movie.reload
            expect(movie.title).to eql('TransformerII')

            expect(response).to redirect_to(movie_path(movie))
            expect(flash[:notice]).to eq("TransformerII was successfully updated.")
        end
    end
end