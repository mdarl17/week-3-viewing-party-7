require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before do 
    User.delete_all
    Movie.delete_all

    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "pass123", password_confirmation: "pass123")

    20.times do |i|
      Movie.create(title: "Movie #{i+1} Title", rating: rand(1..10), description: "This is a description about Movie #{i+1}")
    end 
  end 

  it 'shows all movies' do 
    location = "Sloan's Lake, CO"

    visit login_path

    fill_in :email, with: @user1.email
    fill_in :password, with: @user1.password
    fill_in :location, with: location

    click_button 'Log In'
    
    click_button "Find Top Rated Movies"

    expect(current_path).to eq("/users/#{@user1.id}/movies")

    expect(page).to have_content("Top Rated Movies")
    
    movie_1 = Movie.first

    click_link(movie_1.title)

    expect(current_path).to eq("/users/#{@user1.id}/movies/#{movie_1.id}")

    expect(page).to have_content(movie_1.title)
    expect(page).to have_content(movie_1.description)
    expect(page).to have_content(movie_1.rating)
  end 
end