class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		#(ratings.sum :score) / ratings.count
		ratings.average :score
	end
end
