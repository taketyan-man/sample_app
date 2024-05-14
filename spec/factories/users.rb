FactoryBot.define do
  factory :user do
    name                  { 'Michael Example' }
    email                 { 'michal@example.com' }
    password              { 'password' }
    password_confirmation { 'password' }
    admin                 { true }
    activated             { true }

    trait :other_user do
      name                  { 'Sterling Archer' }
      email                 { 'duchess@example.com' }
      password              { 'password' }
      password_confirmation { 'password' }
      admin                 { false }
      activated             { true }     
    end
  end

  factory :continuous_users, class: User do
    sequence(:name)       { |n| "User #{n}" } 
    sequence(:email)      { |n| "user-#{n}@example.com" }
    password              { 'password' }
    password_confirmation { 'password' }
    activated             { true }
  end
end