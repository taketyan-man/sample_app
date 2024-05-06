require "rails_helper"

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do
    it "errors should be when invalid signup" do
      visit signup_path
      fill_in "Name",         with: ''
      fill_in "Email",        with: 'user@valid'
      fill_in "Password",     with: 'foo'
      fill_in "Confirmation", with: 'bar'
      click_button 'Create my account'
      
      expect(page).to have_selector 'div#error_explanation'
      expect(page).to have_selector 'div.field_with_errors'
    end
  end
end
 