class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, :dependent => :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	validates :name, presence: true

	#def average_rating
		#the good
		#ratings.average :score
		
		#the bad
		#(ratings.sum :score) / ratings.count
	
		#the ugly
		#summa = ratings.inject (0) { |result, element| result + element.score }
		#summa / ratings.count.to_f
	#end

	def to_s
		"#{name}, #{brewery.name}"
	end
end
