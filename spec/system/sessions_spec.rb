require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  

  describe "POST /login" do
    context 'login valid' do
      let(:user) { FactoryBot.create(:user) }
     
      it 'login with valid information' do
        visit login_path
     
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
     
        expect(page).to_not have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
        expect(page).to have_no_link 'Log in', href:login_path
        expect(page).to have_link 'Log out', href:logout_path
        expect(page).to have_link 'Profile', href:user_path(user)

      end

      it "login with invalid only password" do
        visit login_path
        
        fill_in      "Email",    with: user.email
        fill_in      "Password", with: "invalid"
        click_button "Log in"
  
        
        expect(page).to     have_selector "div.alert.alert-danger"

        visit root_path
        expect(page).to_not have_selector "div.alert.alert-danger"
      end
    end

    it "login with invalid information" do
      visit login_path

      fill_in      "Email",    with: ""
      fill_in      "Password", with: ""
      click_button "Log in"

      expect(page).to     have_selector "div.alert.alert-danger"

      visit root_path
      expect(page).to_not have_selector "div.alert.alert-danger"
    end

  end
end
