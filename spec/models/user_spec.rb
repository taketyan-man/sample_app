require "rails_helper"

RSpec.describe ApplicationHelper, type: :request do
  let(:user) { User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar") }

  describe "user model" do
    it "should be valid" do
      expect(user).to be_valid
    end

    it "name shuld be valid" do
      user.name = " "
      expect(user).to_not be_valid
    end

    it "email shuld be valid" do
      user.email = " "
      expect(user).to_not be_valid
    end

    it "name should not be too long" do
      user.name =  "a" * 52
      expect(user).to_not be_valid
    end

    it "name should not be too long" do
      user.email =  "#{'a' * 244}@example.com"
      expect(user).to_not be_valid
    end

    it "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it "email addresses shuld be unique" do
      duplicate_user = user.dup
      duplicate_user_email = user.email.upcase
      user.save
      expect(duplicate_user).to_not be_valid
    end

    it "email should be saved as downcase" do
      mixed_case_email = "FOoBar@eXaMple.Com"
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end

    it "password should be valid" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to_not be_valid
    end

    it "password should not be too shourt" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to_not be_valid
    end
  end

  describe '#authenticated?' do
   it 'digestがnilならfalseを返すこと' do
     expect(user.authenticated?('')).to be_falsy
   end
 end
end