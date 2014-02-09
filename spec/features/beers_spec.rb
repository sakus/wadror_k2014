require 'spec_helper'
include OwnTestHelper

describe "Beers" do
	
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
	let!(:user) { FactoryGirl.create :user }

	before :each do
    	sign_in(username:"Pekka", password:"Foobar1")
    end

    it "can be added via the www form when using a valid name" do
    	visit new_beer_path
    	fill_in('beer[name]', with:'autotestibisse')
    	expect {click_button "Create Beer"}.to change{Beer.count}.from(0).to(1)
    end

	it "cannot be added via www form using an invalid name" do
		visit new_beer_path
		click_button "Create Beer"
		expect(Beer.count).to eq(0)
		expect(page).to have_content 'Name can\'t be blank'
	end

end