require 'rails_helper'

feature "Todo list", :type => :feature do

  scenario "create a new todo list" do
    sign_in("tester@example.tld", "test-password")
    click_link "Lists"

    create_new_list("New test list")
  end

  scenario "edit list title" do
    sign_in("tester@example.tld", "test-password")
    click_link "Lists"

    create_new_list("New test list")

    expect(current_path).to eq(lists_path)
    expect(page).to have_content("Edit")
    click_link "Edit"

    expect(current_path).to eq(edit_list_path)
    expect(page).to have_content("Edit list")
    fill_in "Title", with: "Updated list title"
    click_button "Update list"
  end

  scenario "delete a list" do
    sign_in("tester@example.tld", "test-password")
    click_link "Lists"

    create_new_list("New test list")

    expect(current_path).to eq(lists_path)
    expect(page).to have_content("Delete")
    click_link "Delete"

    expect(current_path).to eq(lists_path)
    expect(page).to have_content("Your list has been deleted")
  end

  #========================================================================#

  private

  def create_user(email, password)
    create(:user, email: email, password: password)
  end

  def sign_in(email, password)
    create_user(email, password)
    visit "/"
    click_link "Sign In"

    expect(current_path).to eq(new_user_session_path)
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign in"

    expect(current_path).to eq("/")
    expect(page).to have_content("Hello, tester@example.tld")
  end

  def create_new_list(list_title)
    expect(current_path).to eq(lists_path)
    click_link "Create new list"

    expect(current_path).to eq(new_list_path)
    expect(page).to have_content("Add a new list")
    fill_in "Title", with: list_title
    click_button "Add new list"

    expect(current_path).to eq(lists_path)
    expect(page).to have_content(list_title)
  end

end
