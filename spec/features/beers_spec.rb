require 'spec_helper'

include OwnTestHelper

describe "Beer pages" do

	let!(:brewery){ FactoryGirl.create :brewery, name: "Koff" }
	let!(:user){ FactoryGirl.create :user }
	
	before :each do
		sign_in(username:'Pekka',password:'Foobar1')
	end

	it "can create a beer with valid data" do
		visit new_beer_path
		select('Koff', from: 'beer[brewery_id]')
		select('Lager', from: 'beer[style]')
		fill_in('beer[name]', with:"Uusi Olut")

		expect{
			click_button "Create Beer"
		}.to change{Beer.count}.from(0).to(1)

		expect(page).to have_content "Uusi Olut"
	end

	it "doesn't create a beer with invalid data" do
		visit new_beer_path
		select('Koff', from: 'beer[brewery_id]')
		select('Lager', from: 'beer[style]')
		fill_in('beer[name]', with:"")

		click_button "Create Beer"

		
		expect(Beer.count).to eq(0)
		expect(page).not_to have_content "Uusi Olut"
		expect(page).to have_content "Name can't be blank"
	end
end