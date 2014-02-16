require 'spec_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return(
			[ Place.new(:name => "Oljenkorsi") ]
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
	end

	it "if many are returned by the API, they are shown at the page" do

		places = [ Place.new(:name => "Bart's"),Place.new(:name => "Pirjon Krouvi"),
		Place.new(:name => "Pikku Jerusalem"), Place.new(:name => "Ebola") ]

		BeermappingApi.stub(:places_in).with("Maunula").and_return(
			places
		)

		visit places_path
		fill_in('city', with: 'Maunula')
		click_button "Search"

		save_and_open_page

		places.each do |baari|
			expect(page).to have_content baari.name
		end
	end

	it "if no bars are found a message is displayed" do

		placename = "Haltiala"

		BeermappingApi.stub(:places_in).with(placename).and_return(
			[]
		)

		visit places_path
		fill_in('city', with: placename)
		click_button "Search"

		expect(page).to have_content "No locations in #{placename}"
	end
end