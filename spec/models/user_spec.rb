require 'spec_helper'

def create_beer_with_rating(score, user)
	beer = FactoryGirl.create(:beer)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_paleale_beer_with_rating(score, user)
	brewery = Brewery.create name:"huhhahhei", year:2000
	beer = Beer.create(name:"jeejeejee", style:"Pale Ale", brewery:brewery)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer	
end

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"
    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  it "is not saved with a bad password (missing numeral)" do
  	user = User.create username:"Pekka", password:"Aabbccddee", password_confirmation:"Aabbccddee"
  	expect(user).not_to be_valid
  	expect(User.count).to eq(0)
  end

  it "is not saved with a bad password (too short)" do
  	user = User.create username:"Pekka", password:"Ab1", password_confirmation:"Ab1"
  	expect(user).not_to be_valid
  	expect(User.count).to eq(0)
  end


  describe "with a proper password" do
     let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

	  user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)

    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
  	let(:user){FactoryGirl.create(:user) }

  	it "has method for determining one" do
  		user.should respond_to :favorite_style
  	end

  	it "without ratings does not have one" do
  		expect(user.favorite_style).to eq(nil)
  	end

  	it "is Lager if only one rating which is Lager" do
  		beer = create_beer_with_rating(50, user)
  		expect(user.favorite_style).to eq("Lager")
  	end

  	it "is Pale Ale if Lager and Pale Ale rated and Pale Ale better" do
  		beer1 = create_beer_with_rating(40, user)
  		beer2 = create_paleale_beer_with_rating(45, user)
  		expect(user.favorite_style).to eq("Pale Ale")
  	end

  end

  describe "favorite brewery" do
  	let(:user){FactoryGirl.create(:user) }

  	it "has method for determining one" do
  		user.should respond_to :favorite_brewery
  	end

  	it "without ratings does not have one" do
  		expect(user.favorite_brewery).to eq(nil)
  	end

  	it "is 'Anonymoys' if only one rating which is from 'Anonymous'" do
  		beer = create_beer_with_rating(50, user)
  		expect(user.favorite_brewery).to eq("anonymous")
  	end

  	it "is 'huhhahhei' if 'anonymous' and 'huhhahhei' rated and 'huhhahhei' better" do
  		beer1 = create_beer_with_rating(40, user)
  		beer2 = create_paleale_beer_with_rating(45, user)
  		expect(user.favorite_brewery).to eq("huhhahhei")
  	end

  end

end