require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  User.delete_all
  Movie.delete_all

  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: "pass123", password_confirmation: "pass123")
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
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

    Movie.all.each do |movie|
      within("#movie-#{movie.id}") do 
        expect(page).to have_link(movie.title)
        expect(page).to have_content("Rating: #{movie.rating}/10")
      end 
    end 
  end 
end