require 'spec_helper'
require 'rails_helper'

describe Movie do

    describe 'find movies with same director' do
        let!(:movie1) { Movie.create!(title: 'Transformer', director: 'Zijian Zhang') }
        let!(:movie2) { Movie.create!(title: 'Kunfu Panda', director: 'Zijian Zhang') }
        let!(:movie3) { Movie.create!(title: "Avengers", director: 'Dont know') }
        let!(:movie4) { Movie.create!(title: "Speed") }
        context 'movies with same director exists' do
            it 'finds movies with same director correctly' do
              expect(Movie.with_same_director(movie1.title)).to eql(['Transformer', 'Kunfu Panda'])
              expect(Movie.with_same_director(movie1.title)).to_not include(['Avengers', 'Speed'])
            end
        end
        context 'movie without director' do
            it "returns nil" do      
                expect(Movie.with_same_director("Speed")).to eq(nil)
            end
        end
    end

  end