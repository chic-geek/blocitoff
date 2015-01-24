require 'rails_helper'

feature "Todo list item", :type => :feature do

  scenario "create to-do item" do
    user = sign_in("tester@example.tld", "test-password")
    create(:list, user: user, title: "to-do list")

    visit lists_path
    click_link "to-do list"

    list = List.last
    expect(current_path).to eq(list_path(list))

    expect(page).to have_content("to-do list")
    click_link "Create new to-do"

    expect(page).to have_content("Create a new to-do item")
    fill_in "Name", with: "purchase groceries"
    click_button "Create new to-do"

    expect(current_path).to eq(list_path(list))
    expect(page).to have_content("Your to-do was created.")
    expect(page).to have_content("purchase groceries")
  end

  private

  def create_user(email, password)
    create(:user, email: email, password: password)
  end

  def sign_in(email, password)
    user = create_user(email, password)
    visit "/"
    click_link "Sign In"

    expect(current_path).to eq(new_user_session_path)
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign in"

    expect(current_path).to eq("/")
    expect(page).to have_content("Hello, #{email}")

    return user
  end

end
