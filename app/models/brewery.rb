class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	validates :name, presence: true
	validates :year, numericality: { 
		only_integer: true,
		greater_than_or_equal_to: 1042,
	}
	validate :year_cant_be_in_the_future

	def year_cant_be_in_the_future
		if year > Time.new.year
			errors.add(:year, "can't be in the future")
		end
	end

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
