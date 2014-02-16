class MembershipsController < ApplicationController
	before_action :set_memberships, only: [:show, :new, :create, :edit, :update, :destroy]

	def index
	end

	def new
		@membership = Membership.new
	end

	def create
		@membership = Membership.new params.require(:membership).permit(:beer_club_id)
		@membership.user_id = current_user.id

		if @membership.save
			current_user.memberships << @membership
			flash[:notice] = "#{current_user.username}, welcome to the club!"
			redirect_to beer_club_path @membership.beer_club
		else
			render :new
		end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_memberships
      @memberships = Membership.all
      @beerclubs = BeerClub.all
    end
end