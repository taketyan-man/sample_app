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
    context "invalid signup inforamtion" do
      it "name blank" do
        expect {
          post users_path, params: { user: { name:  " ",
                                              email: "user@invalid.com",
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
        }.to_not change(User, :count)
      end

      it "password_confirmation dont match password" do
        expect {
          post users_path, params: { user: { name:  "name",
                                             email: "user@invalid.com", 
                                             password:              "foobar",
                                             password_confirmation: "bar" } }
        }.to_not change(User, :count)
      end
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
      log_in(user)
      expect(logged_in?).to be_truthy
 
      delete logout_path
      expect(logged_in?).to_not be_truthy
    end
  end

  describe 'get /users/{id}/edit' do
    let(:user) { FactoryBot.create(:user) }
   
    it 'should get edit' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end
   
    context 'when not logged in' do
      it 'empty flash' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end
   
      it 'should redirect edit' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user, :other_user) }
      it 'empty flash' do
        log_in(other_user)
        get edit_user_path(user)
        expect(flash).to be_empty
      end

      it 'redirect root' do
        log_in(user)
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end

  end
 

  describe 'UPDATE /users' do
    let(:user) { FactoryBot.create(:user) }

    it "should post user" do
      post login_path, params: { session: { email:    user.email,
                                            password: user.password } }
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    it "successful edit" do
      post login_path, params: { session: { email: user.email,
      password: user.password } }
      get edit_user_path(user)
      name =  "Foobar"
      email = "foo@bar.com"
      patch user_path(user), params: { user: { name:  name,
                                                email: email,
                                                password:              "",
                                                password_confirmation: "" } }
      expect(response).to redirect_to user                         
      expect(flash).to be_any
      user.reload
      expect(user.name).to eq(name)
      expect(user.email).to eq(email)
    end

    context 'when not logged in' do
      it 'not empty flash' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).to_not be_empty
      end

      it 'redirect login_path' do
        patch user_path(user), params: { userd: { name:  user.name, 
                                                  email: user.email } }
        expect(response).to redirect_to login_path                                       
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:user, :other_user) }

      before do
        log_in user
        patch user_path(other_user), params: { user: { name:  other_user.name,
                                                       email: other_user.email } }
      end

      it 'empty flash' do
        expect(flash).to be_empty
      end

      it 'redirect root_path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'invalid edi information' do
      before do
        log_in user
        patch user_path(user), params: { user: { name:  '',
                                                email: 'foo@invalid',
                                                password:              'foo',
                                                password_confirmation: 'bar' } }
      end

      it "unsuccessful edit" do
        user.reload
        expect(user.name).to_not eq('')
        expect(user.email).to_not eq('')
        expect(user.password).to_not eq('foo')
        expect(user.password_confirmation).to_not eq('bar')
      end

      it "should 4 errors" do
        expect(response.body).to include 'The form contains 4 errors.' 
      end

      it "should redirect edit" do
        expect(response.body).to include full_title('Edit user')
      end
    end
  end
end