require "rails_helper"

RSpec.describe "Delete chirp", type: :system do
  before do
    login
  end

  it "allows users to delete their own chirps", js: true do
    visit root_path

    # Create a chirp
    fill_in "chirp_content", with: "This chirp will be deleted"
    click_button "Chirp!"

    expect(page).to have_text("This chirp will be deleted")

    # Delete the chirp
    accept_confirm do
      click_button "Delete", match: :first
    end

    expect(page).to have_no_text("This chirp will be deleted")
  end

  it "does not show delete button for other users' chirps" do
    # Create a chirp as the current user
    other_user = User.create!(name: "other_user", email: "other@example.com", password: "password")
    other_user.chirps.create!(content: "Other user's chirp")

    visit root_path

    # The current user should not see a delete button for other user's chirps
    expect(page).to have_text("Other user's chirp")
    expect(page).to have_no_button("Delete")
  end
end
