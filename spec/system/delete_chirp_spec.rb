require "rails_helper"

RSpec.describe "Delete chirp", type: :system do
  before do
    login
  end

  it "allows user to delete their own chirp" do
    visit root_path

    fill_in "chirp_content", with: "This chirp will be deleted"
    click_button "Chirp!"

    expect(page).to have_text("This chirp will be deleted")

    # Accept the confirmation dialog
    accept_confirm do
      click_link "Delete"
    end

    expect(page).not_to have_text("This chirp will be deleted")
  end

  it "does not show delete link for other users' chirps" do
    # Create another user and their chirp
    other_user = User.create!(name: "other_user", password: "password")
    other_user.chirps.create!(content: "Other user's chirp")

    visit root_path

    # The current user should not see a delete link for the other user's chirp
    expect(page).not_to have_link("Delete")
  end
end
