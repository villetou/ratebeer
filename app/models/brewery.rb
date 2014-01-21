class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	#def average_rating
	#	ratings.average :score
	#end
end
