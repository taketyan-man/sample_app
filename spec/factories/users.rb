FactoryBot.define do
  factory :user do
    name { 'Michael Example' }
    email { 'michal@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
  end
end