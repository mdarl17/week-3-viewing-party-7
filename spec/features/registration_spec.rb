require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name, unique email, password, and matching password confirmation' do
    User.delete_all

    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with: 'pass123'
    fill_in :user_password_confirmation, with: 'pass123'
    
    click_button 'Create New User'
    
    user = User.last

    expect(current_path).to eq(user_path(user.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    user_1 = User.create!(name: 'User One', email: 'notunique@example.com', password: 'pass123')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with: 'pass456'
    fill_in :user_password_confirmation, with: 'pass456'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end

  it "does not create a user if name is blank" do 
    visit register_path 

    fill_in :user_email, with: 'someemail@yahoo.com'
    fill_in :user_password, with: 'pass1111'
    fill_in :user_password_confirmation, with: 'pass1111'

    click_button 'Create New User'
    expect(page).to have_content("Name can't be blank")
  end

  it "does not create a user if email is blank" do 
    visit register_path 

    fill_in :user_name, with: 'Mitch Kumstein'
    fill_in :user_password, with: 'pass1111'
    fill_in :user_password_confirmation, with: 'pass1111'

    click_button 'Create New User'
    expect(page).to have_content("Email can't be blank")
  end

  it "does not create a user if password is blank" do 
    visit register_path 

    fill_in :user_name, with: 'Mitch Kumstein'
    fill_in :user_email, with: 'someemail@yahoo.com'
    fill_in :user_password_confirmation, with: 'pass1111'

    click_button 'Create New User'
    expect(page).to have_content("Password can't be blank")
  end

  it "does not create a user if password confirmation is blank" do 
    visit register_path 

    fill_in :user_name, with: 'Mitch Kumstein'
    fill_in :user_email, with: 'someemail@yahoo.com'
    fill_in :user_password, with: 'pass1111'

    click_button 'Create New User'
    expect(page).to have_content("Password Confirmation doesn't match Password")
  end

  it "does not create a user if password and password confirmation don't match" do 
    visit register_path 

    fill_in :user_name, with: 'Mitch Kumstein'
    fill_in :user_email, with: 'someemail@yahoo.com'
    fill_in :user_password, with: 'pass1111'
    fill_in :user_password_confirmation, with: 'pass1112'

    click_button 'Create New User'
    expect(page).to have_content("Password Confirmation doesn't match Password")
  end
end
