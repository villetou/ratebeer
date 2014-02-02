class Membership < ActiveRecord::Base
	belongs_to :beer_club
	belongs_to :user

	validate :validate_user_not_in_club

	def validate_user_not_in_club
		if beer_club.members.include? user
			errors.add(:user_id, "User is already in the club.")
		end
	end
end