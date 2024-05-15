require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  
  let(:user) { FactoryBot.create(:user) }

  describe 'when logged in' do
    context 'header' do
      before do
        log_in(user)
        visit root_path
      end

      it 'should be 7urls' do
        expect(page).to have_link 'sample app', href:root_path
        expect(page).to have_link 'Home',       href:root_path
        expect(page).to have_link 'Help',       href:help_path
        expect(page).to have_link 'Users',      href:users_path
        expect(page).to have_link 'Profile',    href:user_path(user) 
        expect(page).to have_link 'Setting',    href:edit_user_path(user)
        expect(page).to have_link 'Log out',    href:logout_path
      end

      it 'on click sample app' do
        click_link 'sample app'
        expect(page.current_path).to eq root_path
      end

      it 'on click Home' do
        click_link 'Home'
        expect(page.current_path).to eq root_path
      end

      it 'on click Help' do
        click_link 'Help'
        expect(page.current_path).to eq help_path
      end

      context 'Account' do
        before do 
          click_link 'Account'
        end

        it 'on click Profile' do
          click_link 'Profile'
          expect(page.current_path).to eq user_path(user)
        end

        it 'on click Settings' do
          click_link 'Settings'
          expect(page.current_path).to eq edit_user_path(user)
        end

        it 'on click Log out' do
          click_link 'Log out'
          expect(page.current_path).to eq root_path
        end
      end
    end

    context 'footer' do
      before do
        log_in(user)
        visit root_path
      end

      it 'on click About' do
        click_link 'About'
        expect(page.current_path).to eq about_path
      end

      it 'on click Contact' do
        click_link 'Contact'
        expect(page.current_path).to eq contact_path
      end
    end
  end

  describe 'when not logged in' do
    context 'header' do
      before do
        visit root_path
      end

      it 'should be 4urls' do
        expect(page).to have_link 'sample app', href:root_path
        expect(page).to have_link 'Home',       href:root_path
        expect(page).to have_link 'Help',       href:help_path
        expect(page).to have_link 'Log in',     href:login_path
      end

      it 'on click sample app' do
        click_link 'sample app'
        expect(page.current_path).to eq root_path
      end

      it 'on click Home' do
        click_link 'Home'
        expect(page.current_path).to eq root_path
      end

      it 'on click Help' do
        click_link 'Help'
        expect(page.current_path).to eq help_path
      end

      it 'on click Log in' do
        click_link 'Log in'
        expect(page.current_path).to eq login_path
      end
    end

    context 'footer' do
      before do
        visit root_path
      end

      it 'on click About' do
        click_link 'About'
        expect(page.current_path).to eq about_path
      end

      it 'on click Contact' do
        click_link 'Contact'
        expect(page.current_path).to eq contact_path
      end
    end
  end
end