require 'spec_helper'

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score,user)
  end
end

def create_beer_with_rating_and_brewery(score, brewery, user)
  beer = FactoryGirl.create(:beer, brewery: brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings_and_brewery(*scores, brewery, user)
  scores.each do |score|
    create_beer_with_rating_and_brewery(score,brewery,user)
  end
end


def create_beer_with_style_and_rating(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_style_and_ratings(*scores, style, user)
  scores.each do |score|
    create_beer_with_style_and_rating(score, style, user)
  end
end



describe User do
  it "has the username set correctly" do
  	user = User.new username:"Pekka"

  	user.username.should == "Pekka"
  	expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
  	user = User.create username:"Pekka"

  	expect(user).not_to be_valid
  	expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
  	user = User.create username:"Pekka", password:"As1", password_confirmation:"As1"

  	expect(user).not_to be_valid
  	User.count.should eq(0)
  end

  it "is not saved with a password where there's only alphabetical characters" do
  	user = User.create username:"Pekka", password:"Aasinsilta", password_confirmation:"Aasinsilta"

  	expect(user).not_to be_valid
  	User.count.should eq(0)
  end

  it "is saved with a proper password" do
  	user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"

  	expect(user).to be_valid
  	expect(User.count).to eq(1)
  end

  describe "with a proper password" do
  	let(:user){ FactoryGirl.create(:user) }

  	it "is saved" do
  		expect(user).to be_valid
  		expect(User.count).to eq(1)
  	end

  	it "and with two ratings, has the correct average rating" do
  		rating = Rating.new score:10
  		rating2 = Rating.new score:20

  		user.ratings << rating
  		user.ratings << rating2

  		expect(user.ratings.count).to eq(2)
  		expect(user.average_rating).to eq(15.0)
  	end
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_beer" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25,user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_style" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of only one rated beer" do
      beer = create_beer_with_rating(10,user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_style_and_ratings(10, 20, 10, 20, 15, 5, "Lager", user)
      best = create_beer_with_style_and_rating(49,"Ale",user)

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_brewery" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of only one rated beer" do
      beer = create_beer_with_rating(10,user);

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest average rating if several beers rated" do
      brewery1 = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery2)

      create_beers_with_ratings_and_brewery(10,15,20,15,10,15,20,brewery1,user)
      create_beers_with_ratings_and_brewery(15,20,30,20,15,40,49,brewery2,user)

      expect(user.favorite_brewery).to eq(brewery2)

    end
  end

end