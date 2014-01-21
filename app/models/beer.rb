class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		#the good
		#ratings.average :score
		
		#the bad
		#(ratings.sum :score) / ratings.count
	
		#the ugly
		summa = ratings.inject (0) { |result, element| result + element.score }
		summa / ratings.count.to_f
	end
end
