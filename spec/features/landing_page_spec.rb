require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: "pass123", password_confirmation: "pass123")
    user2 = User.create(name: "User Two", email: "user2@test.com", password: "pass456", password_confirmation: "pass456")
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do
    user1 = User.create(name: "User One", email: "user1@test.com", password: "pass123", password_confirmation: "pass123")
    user2 = User.create(name: "User Two", email: "user2@test.com", password: "pass456", password_confirmation: "pass456")

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end 

  it "has a link to log in" do
    User.delete_all
    
    user = User.create!(name: "Matt", email: "mdarl17@gmail.com", password: "pass123", password_confirmation: "pass123")
    
    visit "/"

    expect(page).to have_link("Log In")

    click_link "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"

    expect(current_path).to eq(user_path(User.last.id))
  end
end