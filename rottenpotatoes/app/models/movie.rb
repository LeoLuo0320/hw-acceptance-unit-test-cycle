class Movie < ActiveRecord::Base

  def self.with_same_director(movie_title)
    director = Movie.find_by(title: movie_title).director
    if director.blank? or director.nil?
      return nil
    end
    return Movie.where(director: director).pluck(:title)
  end
end
