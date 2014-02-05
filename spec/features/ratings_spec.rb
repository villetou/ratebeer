require 'spec_helper'
include OwnTestHelper

describe "Rating" do 
	let!(:brewery){ FactoryGirl.create :brewery, name: "Koff" }
	let!(:beer1){ FactoryGirl.create :beer, name: "Iso 3", style: "Lager", brewery:brewery }
	let!(:beer2){ FactoryGirl.create :beer, name: "Karhu", brewery:brewery }
	let!(:user){ FactoryGirl.create :user }

	before :each do
		sign_in(username:"Pekka",password:"Foobar1")
	end

	it "when given, is registered to the beer and user who is signed in" do
		visit new_rating_path
		select('Iso 3', from: 'rating[beer_id]')
		fill_in('rating[score]', with: '15')

		expect{
			click_button "Create Rating"
		}.to change{Rating.count}.from(0).to(1)

		expect(user.ratings.count).to eq(1)
		expect(beer1.ratings.count).to eq(1)
		expect(beer1.average_rating).to eq(15.0)

	end

	it "shows all ratings on the ratings page" do

		ratings1 = [20,10,30,10,20,40,10]
		ratings2 = [30,20,10,5,1,5,9]

		ratings1.each do |score|
			FactoryGirl.create(:rating, score:score, beer:beer1, user:user)
		end

		ratings2.each do |score|
			FactoryGirl.create(:rating, score:score, beer:beer2, user:user)
		end

		expect(Rating.count).to eq(ratings1.count+ratings2.count)

		visit ratings_path

		ratings1.each do |score| 
			expect(page).to have_content "#{beer1.name} #{score}"
		end

		ratings2.each do |score| 
			expect(page).to have_content "#{beer2.name} #{score}"
		end

		expect(page).to have_content("Number of ratings #{ratings1.count+ratings2.count}")
	end

	it "shows users ratings on the user's page" do

		user2 = FactoryGirl.create :user, username:"Kaaleppi", password:"Secret1", password_confirmation:"Secret1"

		ratings1 = [20,10,30,10,20,40,10]
		ratings2 = [30,20,10,5,1,5,9]

		ratings1.each do |score|
			FactoryGirl.create(:rating, score:score, beer:beer1, user:user)
		end

		ratings2.each do |score|
			FactoryGirl.create(:rating, score:score, beer:beer2, user:user2)
		end

		expect(Rating.count).to eq(ratings1.count+ratings2.count)

		visit user_path(user)

		ratings1.each do |score| 
			expect(page).to have_content "#{beer1.name}, #{score}"
		end

		ratings2.each do |score| 
			expect(page).not_to have_content "#{beer2.name}, #{score}"
		end

		#save_and_open_page
		expect(page).to have_content("Has #{ratings1.count} ratings")
	end

	it "deleting a rating from user's site removes it from the database"  do
		score = 20

		FactoryGirl.create(:rating, score:score, beer:beer1, user:user)

		expect(Rating.count).to eq(1)

		visit user_path(user)

		expect(page).to have_content "#{beer1.name}, #{score}"

		expect{
			click_on "delete"
		}.to change{Rating.count}.from(1).to(0)
	end

	it "should show favorite style and brewery on user page" do
		FactoryGirl.create(:rating, score:49, beer:beer1, user:user)

		expect(Rating.count).to eq(1)

		visit user_path(user)

		expect(page).to have_content "Favorite style: #{user.favorite_style}"
		expect(page).to have_content "Favorite brewery: #{user.favorite_brewery.name}"

	end
end