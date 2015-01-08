require 'rails_helper'

feature "User Registration", :type => :feature do

  ## Set the scenario: user registration with valid details
  scenario "with valid details" do

    ## Visit app route
    visit "/"

    ## Use click_link method to click the 'Sign up' button
    click_link "Sign up"

    ## Expect the url to be the new user registration.
    expect(current_path).to eq(new_user_registration_path)

    ## Fill out the sign up form with the appropriate details
    ## and click the sign up button
    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    fill_in "Password confirmation", with: "test-password"
    click_button "Sign up"

    ## Expect the path to be back at the app root with a confimation :notice
    expect(current_path).to eq "/"
    expect(page).to have_content(
      "A message with a confirmation link has been sent to your email address.
      Please follow the link to activate your account."
    )

    ## Open the sent email from x email address and with x subject line
    ## visit the link in email that has the content 'Confirm my account'
    open_email "tester@example.tld", with_subject: "Confirmation instructions"
    visit_in_email "Confirm my account"

    ## Back out of the email and at the new_user_session_path
    ## Expect the page to have the below content
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Your email address has been successfully confirmed."

    ## Fill out the sign in form with below details and click the button with 'Log in' text
    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    click_button "Log in"

    ## Jump back to app root and expect the page to have the below content
    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Hello, tester@example.tld"
  end

end
