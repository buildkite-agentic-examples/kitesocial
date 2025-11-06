require "rails_helper"

RSpec.describe "User profile", type: :system do
  let(:alice) { User.create!(name: "alice", email: "alice@example.com", password: "secretstuff") }
  let(:bob) { User.create!(name: "bob", email: "bob@example.com", password: "opensesame") }
  let(:eve) { User.create!(name: "eve", email: "eve@example.com", password: "spyvsspy") }

  before do
    login(as: alice)
  end

  describe "follower count" do
    it "displays the count of followers on the user profile page" do
      # Bob has two followers: alice and eve
      alice.friends << bob
      eve.friends << bob

      visit user_path(bob)

      expect(page).to have_content("2 followers")
    end

    it "displays singular 'follower' when count is 1" do
      # Bob has one follower: alice
      alice.friends << bob

      visit user_path(bob)

      expect(page).to have_content("1 follower")
    end

    it "displays '0 followers' when user has no followers" do
      visit user_path(bob)

      expect(page).to have_content("0 followers")
    end
  end
end
