require 'rails_helper'


RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  describe "#root" do
    it 'Should get root' do
      get root_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title()
    end
  end

  describe "#help" do
    it "Should get help" do
      get help_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title("Help")
    end
  end

  describe '#about' do
    it "Should get about" do
      get about_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title("About")
    end
  end

  describe '#contact' do
    it "Shuold get contact" do
      get contact_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title("Contact")
    end
  end
end
