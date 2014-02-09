require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Mikko", password:"Salaisuus1", password_confirmation:"Salaisuus1" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "are shown in the page together with how many there are" do
    FactoryGirl.create(:rating, score:15, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    visit ratings_path
    expect(Rating.count).to eq(2)
    expect(page).to have_content 'Number of ratings: 2'
    expect(page).to have_content 'iso 3 15 Pekka'
    expect(page).to have_content 'Karhu 30 Pekka'
  end

  it "is only shown on the correct user's page" do
    FactoryGirl.create(:rating, score:15, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    FactoryGirl.create(:rating, score:35, beer:beer2, user:user2)
    visit user_path(user)
    expect(page).to have_content 'has made 2 ratings'
    expect(page).to have_content 'iso 3 15'
    expect(page).to have_content 'Karhu 30'
    expect(page).not_to have_content 'Karhu 35'
    visit user_path(user2)
    expect(page).to have_content 'has made 1 rating'
    expect(page).to have_content 'Karhu 35'
    expect(page).not_to have_content 'iso 3 15'
    expect(page).not_to have_content 'Karhu 30'
  end

  it "is deleted from the database when deleted through the www page" do
    FactoryGirl.create(:rating, score:15, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    visit user_path(user)
    expect{
      first(:link, 'delete').click
    }.to change{Rating.count}.from(2).to(1)
  end

end
