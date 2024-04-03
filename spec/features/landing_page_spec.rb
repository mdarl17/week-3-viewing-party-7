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
end