require "rails_helper"

RSpec.describe "Searching for users", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    create(:user, first_name: "Bob", last_name: "Jones")
    create(:user, first_name: "Bob", last_name: "Smith")
    create(:user, first_name: "Jacob", last_name: "Smith")
  end

  context "when searching one name" do
    it "finds users by first name" do
      visit root_path
      fill_in "Search", with: "Bob"
      click_on "Search"

      expect(page).to have_content("Bob Jones")
      expect(page).to have_content("Bob Smith")
      expect(page).not_to have_content("Jacob Smith")
    end

    it "finds users by last name" do
      visit root_path
      fill_in "Search", with: "Smith"
      click_on "Search"

      expect(page).to have_content("Jacob Smith")
      expect(page).to have_content("Bob Smith")
      expect(page).not_to have_content("Bob Jones")
    end
  end

  context "when searching with two names" do
    before do
      create(:user, first_name: "Amanda", last_name: "Gaines")
    end

    it "finds users by both names" do
      visit root_path
      fill_in "Search", with: "Bob Smith"
      click_on "Search"

      expect(page).to have_content("Jacob Smith")
      expect(page).to have_content("Bob Smith")
      expect(page).to have_content("Bob Jones")

      expect(page).not_to have_content("Amanda Gaines")
    end

    it "ignores extra names" do
      visit root_path
      fill_in "Search", with: "Amanda Gaines Bob Jones Smith Johnson Hart"
      click_on "Search"

      expect(page).to have_content("Amanda Gaines")

      expect(page).not_to have_content("Jacob Smith")
      expect(page).not_to have_content("Bob Smith")
      expect(page).not_to have_content("Bob Jones")
    end
  end
end
