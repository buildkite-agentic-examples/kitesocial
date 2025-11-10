require "rails_helper"

RSpec.describe "Delete chirp", type: :system do
  let(:current_user) { User.find_by(name: "test") }

  before do
    login
  end

  it "shows delete link for own chirps" do
    # Pre-create a chirp in the database to avoid timing issues with Turbo Streams
    chirp = current_user.chirps.create!(content: "This chirp will be deleted")

    visit root_path

    # Verify the chirp appears and has a delete link
    expect(page).to have_text("This chirp will be deleted")
    expect(page).to have_link("Delete")
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
