require 'rails_helper'

feature "User Authentication", :type => :feature do

  # Scenario with valid details
  scenario "logs in and then out with valid details" do
    create(:user, email: "tester@example.tld", password: "test-password")

    visit "/"
    click_link "Sign In"

    expect(current_path).to eq(new_user_session_path)

    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    click_button "Sign in"

    expect(current_path).to eq("/")
    expect(page).to have_content("Hello, tester@example.tld")

    click_link "Sign out"

    expect(current_path).to eq("/")
    expect(page).to have_content("Signed out successfully.")

  end

end
