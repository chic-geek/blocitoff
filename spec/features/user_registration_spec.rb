require 'rails_helper'

feature "User Registration", :type => :feature do

  # Set the scenario: user registration with valid details
  scenario "with valid details" do

    # Visit app route
    visit "/"

    # Use click_link method to click the 'Sign up' button
    click_link "Sign up"

    # Expect the url to be the new user registration.
    expect(current_path).to eq(new_user_registration_path)

    # Fill out the sign up form with the appropriate details
    # and click the sign up button
    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    fill_in "Password confirmation", with: "test-password"
    click_button "Sign up"

    # Expect the path to be back at the app root with a confimation :notice
    expect(current_path).to eq "/"
    expect(page).to have_content(
      "A message with a confirmation link has been sent to your email address.
      Please follow the link to activate your account."
    )

    # Open the sent email from x email address and with x subject line
    # visit the link in email that has the content 'Confirm my account'
    open_email "tester@example.tld", with_subject: "Confirmation instructions"
    visit_in_email "Confirm my account"

    # Back out of the email and at the new_user_session_path
    # Expect the page to have the below content
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Your email address has been successfully confirmed."

    # Fill out the sign in form with below details and click the button with 'Log in' text
    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    click_button "Log in"

    # Jump back to app root and expect the page to have the below content
    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Hello, tester@example.tld"
  end

  # Now to work on the edge cases, each one will be a scenario within
  # invalid details context which itself is within the User registration
  # feature spec (this file).
  context "with invalid details" do

    # before we do anything, let's visit the new user sign up path
    before do
      visit new_user_registration_path
    end

    scenario "blank fields" do
      expect_fields_to_be_blank
      click_button "Sign up"
      expect_error_msgs "Email can't be blank", "Password can't be blank"
    end

    scenario "email address is invalid" do
      fill_in "Email", with: 'invalid-email'
      fill_in "Password", with: 'test-password'
      fill_in "Password confirmation", with: 'test-password'
      click_button "Sign up"
      expect_error_msgs "Email is invalid"
    end

    # In order for this to work, create a users factory to begin with.
    # For a little more on factory_girl check out: http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md Defining factories.
    scenario "email address already exists" do
      create(:user, email: "tester2@example.tld")
      fill_in "Email", with: "tester2@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      click_button "Sign up"
      expect_error_msgs "Email has already been taken"
    end

    scenario "password confirm incorrect" do
      fill_in "Email", with: "tester@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "other-test-password"
      click_button "Sign up"
      expect_error_msgs "Password confirmation doesn't match Password"
    end

    # Create a couple variables to make this test easy to change should
    # a new password length be required.
    scenario "password too short" do
      min_password_length = 8
      too_shorter_password = 'a' * (min_password_length - 1)
      fill_in "Email", with: 'tester3@example.tld'
      fill_in "Password", with: too_shorter_password
      fill_in "Password confirmation", with: too_shorter_password
      click_button "Sign up"
      expect_error_msgs "Password is too short (minimum is 8 characters)"
    end

  end

  private

  # Check to make sure error messages are page content...
  # The method below takes parameters, those params then become an array of all passed in, in this case an array of all the messages.
  # Next we have an expectation for the page to have content regarding no. of errors and a statement.
  # Within the ul on the page (this holds the error messages and displays to user in UI)
  # For each message loop through and expect the page to have li elements with the string value of each message looped through.
  def expect_error_msgs(*messages)
    within "#error_explanation" do
      error_count = messages.size
      expect(page).to have_content "#{error_count} #{'error'.pluralize(error_count)} prohibited this user from being saved"
      within "ul" do
        expect(page).to have_css "li", count: error_count
        messages.each do |expected_msg|
          expect(page).to have_selector "li", text: expected_msg
        end
      end
    end
  end

  # The password fields don't have value attributes in HTML output, so with: syntax doesn't work.
  # This method is simple enough to not require commenting.
  def expect_fields_to_be_blank
    expect(page).to have_field("Email", with: "", type: "email")
    expect(find_field("Password", type: "password").value).to be_nil
    expect(find_field("Password confirmation", type: "password").value).to be_nil
  end

end
