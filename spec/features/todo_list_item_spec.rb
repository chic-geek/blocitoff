require 'rails_helper'

feature "Todo list item", :type => :feature do

  scenario "create item" do

    # user var equates to signing in a user with said credentials.
    user = sign_in("tester@example.tld", "test-password")

    # create a list which is for above user, with the title 'to-do list'
    create(:list, user: user, title: "to-do list")

    # visit /lists and click the link (list) 'to-do list'
    visit lists_path
    click_link "to-do list"

    # create list var that equates to the last list element (which will be
    # the above list we just created)
    list = List.last

    # current path should now be /list/:id, passing in the above list var
    expect(current_path).to eq(list_path(list))

    # page should have the list 'to-do list' on it
    expect(page).to have_content("to-do list")

    # click create new to-do
    click_link "Create new to-do"

    # takes you to new item form, controller#action pair of: items#new
    expect(page).to have_content("Create a new to-do item")

    # page has the content 'create...'
    fill_in "Name", with: "purchase groceries"

    # fill out form and click button 'create new to-do'
    click_button "Create new to-do"

    # this redirects and current path should be /lists/:id
    expect(current_path).to eq(list_path(list))

    # page to have content 'your to-do was created'
    expect(page).to have_content("Your to-do was created.")

    # and also have the new to-do item, DONE!!
    expect(page).to have_content("purchase groceries")
  end

  scenario "delete item" do

    # sign in...
    user = sign_in("tester@example.tld", "test-password")

    # a little setup
    testList = create(:list, user: user, title: "Shopping list")
    testItem = create(:item, name: "Fetch milk", list: testList)

    list = List.last
    item = list.items.last
    item = item.id

    visit lists_path
    click_link testList.title

    expect(current_path).to eq(list_path(list))
    expect(page).to have_content(testList.title)
    expect(page).to have_content(testItem.name)
    expect(page).to have_link("", href: list_item_path(list, item))
    click_link list_item_path(list, item)

    # expect(current_path).to eq(list_path(list))
    # expect(page).not_to have_content(testItem.name)
    # expect(page).to have_content("Your task has been marked as complete")
  end

  #========================================================================#

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
