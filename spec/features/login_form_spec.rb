require "rails_helper"

RSpec.describe "Login Page", type: :feature do 
	before(:each) do 
		visit root_path
		click_link "Log In"
	end
	it "will not give users access without a valid email" do 
    user = User.create!(name: "Matt", 
											  email: "mdarl17@gmail.com", 
												password: "pass123", 
												password_confirmation: "pass123")

    expect(current_path).to eq(login_path)

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)

    fill_in :email, with: "mdarls17@gmail.com"
    fill_in :password, with: user.password

    click_button "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid email or password")
  end

  it "will not give users access without a valid password" do 
		user = User.create!(name: "Matt", 
												email: "mdarl17@gmail.com", 
												password: "pass123", 
												password_confirmation: "pass123")

    expect(current_path).to eq(login_path)

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)

    fill_in :email, with: "mdarl17@gmail.com"
    fill_in :password, with: "pass12123"

    click_button "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid email or password")
  end

	it "keeps track of a user's current location" do
		user = User.create!(name: "Matt", 
												email: "mdarl17@gmail.com", 
												password: "pass123", 
												password_confirmation: "pass123")

		expect(page).to have_field(:location)

		fill_in :email, with: user.email
		fill_in :password, with: user.password
		fill_in :location, with: "Bloomington, IN"

		click_button "Log In"

		expect(current_path).to eq(user_path(user.id))

		expect(page).to have_content("Bloomington, IN")
	end
end 