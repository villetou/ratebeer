class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	validates :username, 	uniqueness: true,
							length: { in: 3..15 }

	validates :password, length: { minimum: 4 },
						 format: { :with => /(?=.*[A-Z])(?=.*[0-9]).{4,}/, message: "must be at least 4 characters and include one number and one letter."}

	has_many :ratings, :dependent => :destroy
	has_many :beers, through: :ratings
	has_many :memberships, :dependent => :destroy
	has_many :beer_clubs, through: :memberships
end
