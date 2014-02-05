require 'spec_helper'

describe Beer do
	it "should be saved to database with a name and style" do
		beer = Beer.create name:"Olvi", style:"Lager"

		beer.should be_valid
		Beer.count.should eq(1)
	end

	it "should not be saved without a name" do
		beer = Beer.create style:"Lager"

		beer.should_not be_valid
		Beer.count.should eq(0)
	end

	it "should not be saved without a style" do
		beer = Beer.create name:"Olvi"

		beer.should_not be_valid
		Beer.count.should eq(0)
	end
end
