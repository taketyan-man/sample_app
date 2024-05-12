require "rails_helper"

RSpec.describe "Users", type: :request do
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
        post users_path, params: { user: { name:  "name",
                                           email: "user@invalid.com", 
                                           password:              "foobor",
                                           password_confirmation: "bar" } }
      }.to_not change(User, :count)
    end
    
    context "signup valid" do
      let(:user_params) { { user: { name:  "Example User",
                                    email: "user@example.com", 
                                    password:              "password",
                                    password_confirmation: "password" } } }

      it "valid signup information" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it "if valid signup flash is" do
        post users_path, params:user_params
        expect(flash).to be_any 
      end

      it "is_log_in" do
        user = FactoryBot.create(:user)
        post login_path, params: { session: { email: user.email,
                                            password: user.password } }
        expect(logged_in?).to be_truthy
        # メールにて本人確認してないためfalseになってしまう
      end
    end
  end

  describe 'DELETE /logout' do
    it 'valid logout information' do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      expect(logged_in?).to be_truthy
 
      delete logout_path
      expect(logged_in?).to_not be_truthy
    end
  end

  describe 'UPDATE /users' do
    let!(:user) { FactoryBot.create(:user) }

    it "should get edit" do
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    context "valid edit inform" do
      it "unsuccessful edit" do
        post login_path, params: { session: { email: user.email,
                                            password: user.password } }
        get edit_user_path(user)
        patch user_path(user), params: { user: { name:  "",
                                                 email: "foo@invalid",
                                                 password:              "foo",
                                                 password_confirmation: "bar" } }
        user.reload
        expect(user.name).to_not eq('')
        expect(user.email).to_not eq('')
        expect(user.password).to_not eq('foo')
        expect(user.password_confirmation).to_not eq('bar') 
      end
    end
  end
end