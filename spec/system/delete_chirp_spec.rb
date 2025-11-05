require "rails_helper"

RSpec.describe "Delete chirp", type: :system do
  let(:current_user) { User.find_by(name: "test") }

  before do
    login
  end

  it "allows users to delete their own chirps", js: true do
    visit root_path

    # Create a chirp
    fill_in "chirp_content", with: "This chirp will be deleted"
    click_button "Chirp!"

    expect(page).to have_text("This chirp will be deleted")

    # Delete the chirp (accept the Turbo confirmation dialog)
    accept_confirm do
      click_link "Delete", match: :first
    end

    expect(page).to have_no_text("This chirp will be deleted")
  end

  it "does not show delete link for other users' chirps" do
    # Create another user and their chirp
    other_user = User.create!(name: "other_user", email: "other@example.com", password: "password")
    other_user.chirps.create!(content: "Other user's chirp")

    # Make the current user follow the other user so the chirp appears in their timeline
    current_user.friends << other_user

    visit root_path

    # The current user should see the chirp but not a delete link for it
    expect(page).to have_text("Other user's chirp")

    # Check that there's no Delete link for this specific chirp
    # Since we're on the timeline, and the current user has no chirps of their own yet,
    # there should be no Delete links at all
    expect(page).to have_no_link("Delete")
  end
end
