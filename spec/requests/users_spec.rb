require "rails_helper"

RSpec.describe ApplicationHelper, type: :request do
  describe '#new' do
    it "should get new" do
      get signup_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe 'POST /users #create' do
    it "invalid signup inforamtion" do
      expect {
        post users_path, params: { user: { name:  "",
                                           email: "user@invalid", 
                                           password:              "foo",
                                           password_confirmation: "bar" } }
      }.to_not change(User, :count)
    end 

    it "valid signup information" do
      expect {
        post users_path, params: { user: { name:  "Example User",
                                           email: "user@example.com", 
                                           password:              "password",
                                           password_confirmation: "password" } }
      }.to change(User, :count).by 1
    end

    it "if valid signup flash is" do
      post users_path, params: { user: { name:  "Example User",
                                          email: "user@example.com", 
                                          password:              "password",
                                          password_confirmation: "password" } }
      expect(flash).to be_any 

    end
  end
end