require "rails_helper"

RSpec.describe ApplicationHelper, type: :request do
  describe '#new' do
    it "should get new" do
      get signup_path
      expect(response).to have_http_status :ok
      expect(response.body).to include full_title('Sign up')
    end
  end
end