class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	#def average_rating
	#	ratings.average :score
	#end

	def print_report
		puts name
		puts "enstablished at year #{year}"
		puts "number of beers #{beers.count}"
		puts "number of ratings #{ratings.count}"
	end

	def restart
		self.year = 2014
		puts "changed year to #{year}"
	end
end
