require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with: 'pass123'
    
    click_button 'Create New User'

    user = User.last

    expect(user).to_not have_attribute(:password)
    expect(user.password_digest).to_not eq("pass123")
    expect(current_path).to eq(user_path(user.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    user_1 = User.create!(name: 'User One', email: 'notunique@example.com', password: 'pass123')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with: 'pass456'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end
end
