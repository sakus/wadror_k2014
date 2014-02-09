require 'spec_helper'

describe Beer do
  
	let(:testbrewery){ Brewery.new name:"automaattitestipanimo", year:2001 }

	it "is saved with a name and a style" do
    	beer = Beer.create name:"automaattitestibisse", style:"Lager", brewery:testbrewery
    	expect(beer).to be_valid
    	expect(Beer.count).to eq(1)
	end

	it "is not saved if missing name" do
    	beer = Beer.create style:"Lager", brewery:testbrewery
    	expect(beer).not_to be_valid
    	expect(Beer.count).to eq(0)
	end

	it "is not saved if missing style" do
    	beer = Beer.create name:"automaattitestibisse", brewery:testbrewery
    	expect(beer).not_to be_valid
    	expect(Beer.count).to eq(0)
	end

end
