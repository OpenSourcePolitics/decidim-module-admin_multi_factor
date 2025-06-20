# frozen_string_literal: true

require "spec_helper"

describe "Admin double authentication", type: :system do
  include Decidim::SanitizeHelper

  let(:organization) { create :organization, default_locale: :en }
  let(:admin) { create :user, :admin, :confirmed, organization: }
  let!(:setting) { Decidim::AdminMultiFactor::Setting.create!(enable_multifactor: true, email: true, sms: true, organization:) }

  before do
    switch_to_host(organization.host)
  end

  describe "Access back office" do
    before do
      # access the elevate page
      login_as admin, scope: :user
      visit decidim.root_path
      find("#trigger-dropdown-account").click
      li = page.all("ul.main-bar__dropdown li")
      li[4].click
      # set the verification code
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Decidim::AdminMultiFactor::BaseVerification).to receive(:generate_code).and_return("1234")
      # rubocop:enable RSpec/AnyInstance
    end

    it "can access back office with email" do
      expect(page).to have_content("Elevate access rights")
      links = page.all("a.button.button__sm.button__secondary.w-40")
      links[0].click # first link is Email
      expect(page).to have_content("Please enter the code:")
      fill_in "digit1", with: 1
      fill_in "digit2", with: 2
      fill_in "digit3", with: 3
      fill_in "digit4", with: 4
      click_link_or_button "Submit"
      expect(page).to have_content("Dashboard #{translated_attribute(organization.name)}")
    end

    it "can access back office with sms" do
      expect(page).to have_content("Elevate access rights")
      links = page.all("a.button.button__sm.button__secondary.w-40")
      links[1].click # second link is Sms
      fill_in "sms_code[phone_number]", with: "0612345678"
      click_link_or_button "Submit"
      expect(page).to have_content("Please enter the code:")
      fill_in "digit1", with: 1
      fill_in "digit2", with: 2
      fill_in "digit3", with: 3
      fill_in "digit4", with: 4
      click_link_or_button "Submit"
      expect(page).to have_content("Dashboard #{translated_attribute(organization.name)}")
    end

    it "can't access back office with email if code is wrong" do
      expect(page).to have_content("Elevate access rights")
      links = page.all("a.button.button__sm.button__secondary.w-40")
      links[0].click # first link is Email
      expect(page).to have_content("Please enter the code:")
      # enters  a wrong code
      fill_in "digit1", with: 5
      fill_in "digit2", with: 6
      fill_in "digit3", with: 7
      fill_in "digit4", with: 8
      click_link_or_button "Submit"
      expect(page).to have_content("The code entered is not valid")
    end

    it "can't access back office with sms if code is wrong" do
      expect(page).to have_content("Elevate access rights")
      links = page.all("a.button.button__sm.button__secondary.w-40")
      links[1].click # second link is Sms
      fill_in "sms_code[phone_number]", with: "0612345678"
      click_link_or_button "Submit"
      expect(page).to have_content("Please enter the code:")
      # enters  a wrong code
      fill_in "digit1", with: 5
      fill_in "digit2", with: 6
      fill_in "digit3", with: 7
      fill_in "digit4", with: 8
      click_link_or_button "Submit"
      expect(page).to have_content("The code entered is not valid")
    end
  end
end
