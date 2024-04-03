require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    User.delete_all

    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "pass123", password_confirmation: "pass123")
    @user2 = User.create!(name: "User Two", email: "user2@test.com", password: "pass456", password_confirmation: "pass456")
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

  it 'if user is logged in, it displays existing users' do
    visit logout_path

    user3 = User.create!(name: "User Three", email: "user3@test.com", password: "pass789", password_confirmation: "pass789")
    visit login_path 

    fill_in :email, with: user3.email
    fill_in :password, with: user3.password

    click_button "Log In"

    visit root_path

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.email)
    end
  end

  it "has a link to log in" do
    user = User.create!(name: "Matt", email: "mdarl17@gmail.com", password: "pass123", password_confirmation: "pass123")
    location = "Sloan's Lake, CO"

    expect(page).to have_link("Log In")

    click_link "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :location, with: location

    click_button "Log In"
    
    expect(current_path).to eq(user_path(user.id))
  end

  it "if a user is logged in, the login/create new user links are disabled and logout link is enabled" do 
    visit login_path

    fill_in :email, with: "user1@test.com"
    fill_in :password, with: "pass123"
  
    click_button "Log In"
    
    visit root_path

    expect(page).to have_button("Logout")
    expect(page).to_not have_link("Log In")
    expect(page).to_not have_link("Create New User")
  end

  it "if a user is logged out, the login/create new user links are enables, and the logout button is disabled" do 
    visit login_path

    fill_in :email, with: "user1@test.com"
    fill_in :password, with: "pass123"
  
    click_button "Log In"
    
    visit root_path
  end

  it "when I'm logged out I don't see existing users" do 
    visit root_path

    expect(page).to_not have_content("Existing Users")

    visit login_path

    fill_in :email, with: "user1@test.com"
    fill_in :password, with: "pass123"
  
    click_button "Log In"
    
    visit root_path

    expect(page).to have_content("Existing Users")
  end

  it "logged in users see other existing users on the landing page as text, not links to other user dashboards" do
    visit login_path

    fill_in :email, with: "user1@test.com"
    fill_in :password, with: "pass123"
  
    click_button "Log In"
    
    visit root_path

    expect(page).to have_content("Existing Users")
    
    User.all.each do |user|
      expect(page).to_not have_link(user.email)
      expect(page).to have_content(user.email)
    end
  end

  it "a visitor can not access a dashboard page, they must be logged in" do 
    visit root_path

    visit user_path(@user1.id)

    expect(current_path).to eq(root_path)
  end

  it "if a visitor tries to access the dashboard, a message alerting them that they need to be logged in is displayed" do
    visit logout_path
    visit root_path
    visit user_path(@user1.id)

    expect(page).to have_content("You must be logged in to see the dashboard")
  end
end