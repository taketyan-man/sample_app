require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "should get new" do
      get login_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'DELETE /logout' do
    before do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
    end

    it 'should valid logout' do
      expect(logged_in?).to be_truthy
 
      delete logout_path
      expect(logged_in?).to_not be_truthy
    end

    it 'should still work after logout in second window' do
      delete logout_path
      delete logout_path
      expect(response).to redirect_to root_path
    end
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
  
    describe 'remember me' do
      it 'login with remembering' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: 1 }}
        expect(cookies[:remember_token]).to_not be_blank
      end

      it 'login without remembering' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: 0 }}
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end

end
